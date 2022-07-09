require 'test_helper'

class AssetTest < ActiveSupport::TestCase
   test "json_serialisation with ecosystem service" do
     asset = Asset.find(1)
     json = asset.to_formatted_json("es")
     assert_equal 6, json["ecosystem_services"].size
     assert_equal 58, json["ecosystem_services"][0]["sorted_materialities"].size
   end

   test "json_serialisation with impact drivers" do
     asset = Asset.find(1)
     json = asset.to_formatted_json("id")
     assert_equal 11, json["impact_drivers"].size
     assert_equal 10, json["impact_drivers"][0]["impacts"].size
   end

end
