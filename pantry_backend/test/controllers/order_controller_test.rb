require 'test_helper'

class OrderControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get order_index_url
    assert_response :success
  end

  test 'should get read' do
    get order_read_url
    assert_response :success
  end

  test 'should get create' do
    get order_create_url
    assert_response :success
  end

  test 'should get destory' do
    get order_destory_url
    assert_response :success
  end
end
