require 'test_helper'

class ImpactDriversControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "#{impact_drivers_url}.json"
    assert_response :success
    # we have 15 impact_drivers
    assert_equal 11, json_response.size
    # should have some impacts
    assert_equal 19, json_response[1]["impacts"].size
    # Check we include justifications here
    assert_equal "Pipelines used to distribute gas have a significant spatial footprint, which can lead to habitat degradation and fragmentation throughout the pipelines' life cycle.", json_response[1]["impacts"][0]["justification"]
    # and some (uniquified) assets
    assert_equal 8, json_response[1]["unique_assets"].size
    assert_nil json_response[1]["drivers"]
  end

  test "should get show" do
    get "#{impact_drivers_url}/2.json"
    assert_response :success
    # should have some impacts
    assert_equal 19, json_response["impacts"].size
    assert_nil json_response["unique_assets"]
    # and some drivers
    assert_equal 15, json_response["drivers"].size
  end
end
