# frozen_string_literal: true

set :output, 'log/cron.log'

every :day, at: '1:00am' do
  rake 'clear_expired_pdf_downloads'
end
