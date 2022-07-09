class PdfDownloadWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(url, dest_pdf, portfolio_id)
    puppeteer = Rails.root.join('vendor/assets/javascripts/puppeteer.js')

    `node --trace-warnings #{puppeteer} '#{url}' #{dest_pdf}`

    store portfolio_id: portfolio_id
    store dest_pdf: dest_pdf
  end
end