require 'test_helper'

class StatTypesControllerTest < ActionController::TestCase
  setup do
    @stat_type = stat_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stat_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stat_type" do
    assert_difference('StatType.count') do
      post :create, stat_type: { name: @stat_type.name }
    end

    assert_redirected_to stat_type_path(assigns(:stat_type))
  end

  test "should show stat_type" do
    get :show, id: @stat_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stat_type
    assert_response :success
  end

  test "should update stat_type" do
    patch :update, id: @stat_type, stat_type: { name: @stat_type.name }
    assert_redirected_to stat_type_path(assigns(:stat_type))
  end

  test "should destroy stat_type" do
    assert_difference('StatType.count', -1) do
      delete :destroy, id: @stat_type
    end

    assert_redirected_to stat_types_path
  end
end
