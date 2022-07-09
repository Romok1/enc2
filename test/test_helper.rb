ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # We now have users in fixtures for authenticated action testing
  fixtures :all


  # Add more helper methods to be used by all tests here...
  def json_response
    @json_rsponse ||= ActiveSupport::JSON.decode @response.body
  end
end
