require 'test_helper'

class StatControllerTest < ActionController::TestCase
  test "should get vacancy count by month in" do
    get :count_by_month_in, :year => 2013
    assert_response :success
  end

  test "should get salary distribution in" do
    get :salary_distribution_in, :year => 2013
    assert_response :success
  end

  test "should get vacancy count by year" do
    get :count_by_year
    assert_response :success
  end

  test "should get vacancy count by month" do
    get :count_by_month
    assert_response :success
  end

  test "should get count by specialization" do
    get :count_by_specialization
    assert_response :success
  end

  test "should get mean salary by specialization in" do
    get :mean_salary_by_specialization_in, :year => 2013
    assert_response :success
  end

  test "should get salary distribution for specialization in year" do
    get :salary_distribution_in_for, :year => 2013, :specialization_name => 'C#'
    assert_response :success
  end

  test "should get specialization trend for specialization in year" do
    get :specialization_trend_in_for, :year => 2013, :specialization_name => 'C#'
    assert_response :success
  end

  test "should get specialization trend for specialization" do
    get :specialization_trend_for, :specialization_name => 'C#'
    assert_response :success
  end
end
