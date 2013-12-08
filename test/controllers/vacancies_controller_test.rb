require 'test_helper'

class VacanciesControllerTest < ActionController::TestCase
  setup do
    @vacancy = vacancies(:one)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vacancies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vacancy" do
    assert_difference('Vacancy.count') do
      post :create, vacancy: { area_id: @vacancy.area_id, created: @vacancy.created, employer_id: @vacancy.employer_id, name: @vacancy.name, salary_from: @vacancy.salary_from, salary_to: @vacancy.salary_to }
    end

    assert_redirected_to vacancy_path(assigns(:vacancy))
  end

  test "should show vacancy" do
    get :show, id: @vacancy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vacancy
    assert_response :success
  end

  test "should update vacancy" do
    patch :update, id: @vacancy, vacancy: { area_id: @vacancy.area_id, created: @vacancy.created, employer_id: @vacancy.employer_id, name: @vacancy.name, salary_from: @vacancy.salary_from, salary_to: @vacancy.salary_to }
    assert_redirected_to vacancy_path(assigns(:vacancy))
  end

  test "should destroy vacancy" do
    assert_difference('Vacancy.count', -1) do
      delete :destroy, id: @vacancy
    end

    assert_redirected_to vacancies_path
  end
end
