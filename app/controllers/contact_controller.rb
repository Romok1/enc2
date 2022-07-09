class ContactController < ApplicationController
  def submission
    AdminMailer.with(
      name: params[:full_name],
      email: params[:email],
      enquiry_type: params[:enquiry_type] || 'feedback',
      message: params[:message]
    ).send_enquiry.deliver_now

    respond_to do |f|
      f.html { redirect_to contact_path }
      f.json do
        render json: {
          status: 200
        }
      end
    end
  end
end
