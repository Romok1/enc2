module Concerns::PDFDownloadable
  extend ActiveSupport::Concern
  included do
    include Concerns::PortfolioAuthorization

    def create_pdf_job(parameters, filename, portfolio_id)
      @job_id = PdfDownloadWorker.perform_async(
        url_for(parameters),
        dest_pdf(filename),
        portfolio_id
      )

      render status: :accepted, json: { jobId: @job_id }
    end

    def fetch_pdf
      job_id = params[:job_id]
      portfolio_id = Sidekiq::Status.get(job_id, :portfolio_id)

      if !user_owns_portfolio?(portfolio_id)
        render status: 403, json: { status: 'Forbidden' }
      elsif Sidekiq::Status.complete?(job_id)
        respond_to do |format|
          format.pdf { send_pdf(Sidekiq::Status.get(job_id, :dest_pdf)) }
          format.json { render json: { status: 'Complete' } }
        end
      elsif Sidekiq::Status.failed?(job_id)
        render status: 500, json: { status: 'Failed' }
      elsif Sidekiq::Status.status(job_id).nil?
        render status: 404, json: { status: 'Invalid job id' }
      else
        render status: 202, json: { status: 'Pending' }
      end
    end

    def send_pdf(dest_pdf)
      File.open(dest_pdf, 'r') do |f|
        send_data f.read, filename: "#{File.basename(dest_pdf)}", type: 'application/pdf'
      end

      File.delete(dest_pdf)
    end

    def pdf_params(controller, align_options, action = :index, existing_params = nil)
      existing_params.to_h.merge({
        controller: controller,
        action: action,
        for_pdf: true,
        user_id: pdf_user.id,
        auth_token: Rails.application.credentials.encore_auth_token
      }).merge(align_options)
    end

    def pdf_timestamp
      Time.now.to_i
    end

    def dest_pdf filename
      Rails.root.join("tmp/#{filename}.pdf").to_s
    end

    def puppeteer_call
      params[:user_id].present? && params[:auth_token] == Rails.application.credentials.encore_auth_token
    end
  end
end
