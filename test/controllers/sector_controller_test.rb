# coding: utf-8
require 'test_helper'

class SectorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "#{sectors_url}.json"
    assert_response :success
    assert_equal 11, json_response.size
    assert_equal 2, json_response[0]["id"]
    assert_equal "Consumer Staples", json_response[0]["name"]
    assert_equal 11, json_response[0]["sub_industries"].size
    assert_equal 1, json_response[0]["sub_industries"][0]["production_processes"].size
  end
  test "should get single" do
    get "#{sectors_url}/1.json"
    assert_response :success
    assert_equal 1, json_response["id"]
    assert_equal "Industrials", json_response["name"]
    assert_equal 22, json_response["sub_industries"].size
    assert_equal 1, json_response["sub_industries"][0]["production_processes"].size
  end
  test "should get single in spanish" do
    get "/es/sectors/1.json"
    assert_response :success
    assert_equal 1, json_response["id"]
    assert_equal "Industria", json_response["name"]
    assert_equal 22, json_response["sub_industries"].size
    assert_equal "Líneas aéreas", json_response["sub_industries"][0]["name"]
    assert_equal 1, json_response["sub_industries"][0]["production_processes"].size
  end

end
