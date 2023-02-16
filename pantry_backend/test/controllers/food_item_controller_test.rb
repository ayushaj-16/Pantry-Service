require 'test_helper'

class FoodItemControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get food_item_index_url
    assert_response :success
  end
end
