class ApplicationController < ActionController::Base
  before_action :set_cms_site
  before_action :set_locale
  before_action :set_translations
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_authentication_carousel_content, unless: :user_signed_in?
  before_action :check_for_pdf

  def set_cms_site
    @cms_site ||= Comfy::Cms::Site.first
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_translations
    @default_locale = I18n.default_locale.to_s
    @locale = I18n.locale.to_s
    @locales_available = %i[en es]
    @translations = I18n.backend.send(:translations)[I18n.locale]
  end

  def set_authentication_carousel_content
    @authentication_carousel_content = I18n.t('authentication_carousel.content').each do |item|
      item[:background_image] = helpers.image_url(item[:background_image])
    end
  end

  def dashboard_pdf_params
    controller = params[:controller].split('/').last.split('_').first
    send("#{controller}_pdf_params")
  end

  def pdf_user
    current_user || User.find(params[:user_id])
  end

  def check_for_pdf
    @for_pdf = params[:for_pdf].present?
  end

  protected

  def configure_permitted_parameters
    keys = %i[
      name
      organisation
      organisation_type_id
      country_id
      agreed_to_contact_for_new_functionality_updates
    ]
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
    devise_parameter_sanitizer.permit(:sign_up, keys: keys + [:terms])
  end

  def are_hash_arrays_equal?(array_1, array_2)
    array_1 = sanitize_params(array_1)
    array_2 = sanitize_params(array_2)

    equal = array_1.count == array_2.count
    return false unless equal

    diff = (array_1 - array_2) + (array_2 - array_1)
    diff.empty?
  end

  def sanitize_params(array)
    array.map { |a| a.each { |k, _v| a[k] = '' if a[k].blank? } }
  end
end
