require 'test_helper'

class NatCapDashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  #   test "get_prod_procs with just sub_inds filter" do
  #     pps = get_production_processes_from_filter({sub_industry_ids: [3,4,5]})
  #     assert_equal 3, pps.count
  #   end

  #   test "get_prod_procs with prod_proc filter" do
  #     pps = get_production_processes_from_filter({sub_industry_ids: [3,4,5], production_process_ids: [2,49]})
  #     assert_equal 2, pps.count
  #   end

  #   test "get_prod_procs with prod_proc filter not in sub_industry" do
  #     #pp 51 is not part of any of the three listed sub_inds - should return empty
  #     pps = get_production_processes_from_filter({sub_industry_ids: [3,4,5], production_process_ids: [51]})
  #     assert_equal 0, pps.count
  #   end
  #

  test 'should redirect to login if not logged in' do
    get '/tools/natural-capital-dashboard/data?type=impacts'
    assert_redirected_to(new_user_session_path)
  end

  test 'should 406 with bad type param' do
    user = users(:regular_user)
    sign_in user

    get '/tools/natural-capital-dashboard/data?type=badgers'
    assert_response :bad_request
  end

  test 'should 400 with no sub_ind' do
    user = users(:regular_user)
    sign_in user

    get '/tools/natural-capital-dashboard/data?type=dependencies'
    assert_response :bad_request
  end

  test 'should 400 with prod_proc only' do
    user = users(:regular_user)
    sign_in user

    get '/tools/natural-capital-dashboard/data?type=dependencies'
    assert_response :bad_request
  end

  test 'should work with single sub_ind param' do
    user = users(:regular_user)
    sign_in user

    get '/tools/natural-capital-dashboard/data?type=dependencies&sub_industry_ids[]=1'
    assert_response :success

    json = JSON.parse(body)
    assert_link 'Airlines', 'Airport services', json
  end

  test "shouldn't be a link to filtered out pp from si" do
    user = users(:regular_user)
    sign_in user
    query_data = SqlTracker.track do
      get '/tools/natural-capital-dashboard/data?type=dependencies&sub_industry_ids[]=5&production_process_ids[]=49'
    end
    assert_response :success

    assert_equal 72, (query_data.values.sum { |a| a[:count] })

    json = JSON.parse(body)
    assert_link 'Aluminium', 'Mining', json
    assert_no_link 'Aluminium', 'Alumina refining', json
  end

  # tests for main endpoint from here
  test 'main should work with single sub_ind param' do
    user = users(:regular_user)
    sign_in user

    get '/tools/natural-capital-dashboard/main?type=dependencies&sub_industry_ids[]=1'
    assert_response :success
  end

  def assert_link(from, to, json)
    link = json.find { |i| i['from'] == from && i['to'] == to }
    assert !link.nil?
  end

  def assert_no_link(from, to, json)
    link = json.find { |i| i['from'] == from && i['to'] == to }
    assert link.nil?
  end
end
