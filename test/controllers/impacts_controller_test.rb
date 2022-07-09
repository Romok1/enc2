require 'test_helper'

class ImpactsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get "#{production_process_impact_driver_url(id: 7, production_process_id: 1)}.json"
    assert_response :success
    # should have some impacts
    assert_equal 6, json_response["impact"].size
    # and some drivers
    assert_equal 5, json_response["impact_driver"].size
  end
end
