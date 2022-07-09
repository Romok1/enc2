# coding: utf-8
module MethodologyHelper
  def csv_download_text
    user_signed_in? ? t('methodology.csv_download.text_logged_in') : t('methodology.csv_download.text_cta')
  end

  def csv_download_button_class
    "csv-download__button" + (user_signed_in? ? '' : ' disabled')
  end

  def csv_download_button_link
    user_signed_in? ? '/ENCORE_DataFiles.zip' : ''
  end
end
