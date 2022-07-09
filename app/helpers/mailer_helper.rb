module MailerHelper
  # For styling use the colors in variables.scss
  def mail_image image
    root_url + 'mail_images/' + image
  end

  def spacer_src
    mail_image('spacer.gif')
  end
end