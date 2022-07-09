class AdminMailer < ApplicationMailer
  ADMIN_EMAIL = Rails.application.credentials.dig(Rails.env.to_sym, :admin_email)
  CODEBASE_EMAIL = Rails.application.credentials.dig(:mailer, :codebase_email)

  def send_enquiry
    I18n.with_locale(:en) do
      @name         = params[:name]
      @email        = params[:email]
      @enquiry_type = I18n.t("form.#{params[:enquiry_type]}")
      @message      = params[:message]

      mail(
        to: [ADMIN_EMAIL, CODEBASE_EMAIL],
        subject: I18n.t('form.new_enquiry_msg', { type: @enquiry_type, name: @name })
      )
    end
  end
end
