# frozen_string_literal: true

FILE_FORMAT = 'ENCORE-(?:agri|mining)-dashboard-download-\d{10}\.pdf'

desc 'Clear expired PDF downloads (over 5 minutes old) from the tmp directory'
task :clear_expired_pdf_downloads do
  matched_files.each do |file|
    File.delete(file) if file_expired?(file)
  end
end

private

def matched_files
  valid_filename_regexp = Regexp.new(FILE_FORMAT)
  tmpdir_path = Rails.root.join('tmp')
  Dir.glob("#{tmpdir_path}/*")
    .select { |file| valid_filename_regexp.match(file) }
end

def file_expired?(file)
  File.stat(file).ctime < 5.minutes.ago
end
