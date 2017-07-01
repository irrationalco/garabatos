require 'test_helper'

class TicketProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_product = ticket_products(:one)
  end

  test "should get index" do
    get ticket_products_url
    assert_response :success
  end

  test "should get new" do
    get new_ticket_product_url
    assert_response :success
  end

  test "should create ticket_product" do
    assert_difference('TicketProduct.count') do
      post ticket_products_url, params: { ticket_product: { ammount: @ticket_product.ammount, discount: @ticket_product.discount, price: @ticket_product.price, product_id: @ticket_product.product_id, ticket_id: @ticket_product.ticket_id } }
    end

    assert_redirected_to ticket_product_url(TicketProduct.last)
  end

  test "should show ticket_product" do
    get ticket_product_url(@ticket_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_product_url(@ticket_product)
    assert_response :success
  end

  test "should update ticket_product" do
    patch ticket_product_url(@ticket_product), params: { ticket_product: { ammount: @ticket_product.ammount, discount: @ticket_product.discount, price: @ticket_product.price, product_id: @ticket_product.product_id, ticket_id: @ticket_product.ticket_id } }
    assert_redirected_to ticket_product_url(@ticket_product)
  end

  test "should destroy ticket_product" do
    assert_difference('TicketProduct.count', -1) do
      delete ticket_product_url(@ticket_product)
    end

    assert_redirected_to ticket_products_url
  end
end
