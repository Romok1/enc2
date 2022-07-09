# coding: utf-8
require 'test_helper'

class AssetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index with default ecossystem services" do
    get "#{assets_url}.json"
    assert_response :success
    assert_equal 8, json_response.size
    assert_equal 6, json_response[0]["ecosystem_services"].size
    assert_nil json_response[0]["impact_drivers"]
  end

  test "should get index with explicit include of ecossystem services" do
    get "#{assets_url}.json?include=es"
    assert_response :success
    assert_equal 8, json_response.size
    assert_equal 6, json_response[0]["ecosystem_services"].size
    assert_equal 58, json_response[0]["ecosystem_services"][0]["sorted_materialities"].size
    assert_nil json_response[0]["impact_drivers"]
  end

  test "should get index with explicit include of impact drivers" do
    get "#{assets_url}.json?include=id"
    assert_response :success
    assert_equal 8, json_response.size
    assert_equal 11, json_response[0]["impact_drivers"].size
    assert_equal 10, json_response[0]["impact_drivers"][0]["impacts"].size
    assert_nil json_response[0]["ecosystem_services"]
  end

  
  test "get index is bad_request with rubbish" do
    get "#{assets_url}.json?include=totalGibbersih"
    assert_response :bad_request
  end

  
  test "should get single" do
    get "#{assets_url}/1.json"
    assert_response :success
  end
end
