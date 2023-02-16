# Controller to hand Order routes
class OrderController < ApplicationController
  # Route to list all orders of an employee
  def index
    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    responses = []

    # TODO: (N+1) query , how to remove, check includes method (order = Order.includes(:order_items).first)
    orders = Order.where('employee_id=?', params[:employee_id])
    orders.each do |order|
      items = OrderItem.where('order_id=?', order.id)
      responses.push(order: { details: order, items: items })
    end

    # puts order
    render json: responses, status: :ok
  end

  # Route to show details of a particular order
  def show
    # ? Assumption - User can only access particular order from all orders page

    # Check for user token validity and correct user id to access
    check = CheckAuthService.check(request.cookies['token'])
    order = Order.find_by_id(params[:id])
    wrong_user = order.employee_id == params[:employee_id]

    render status: :unauthorized and return unless check && wrong_user

    # find items linked with this particular order
    order_items = OrderItem.where('order_id=?', params[:id])

    render json: { order: order, item: order_items }
  end

  # Route to add new order
  def create
    # TODO: Use Associations instead of this (build,create,etc)

    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    items = order_params[:items]

    # !ERROR BLOCK
    # p 'start'
    # p order_params
    # p order_params.delete(:instructions)
    # p 'end'
    # p 'start'
    # p order_params
    # p order_params.class
    # order_params_hash = order_params.to_h
    # p "hash"
    # p order_params_hash
    # p order_params_hash.class
    # p 'end'

    order = []
    order_items = []
    order_prep_time = 0

    # * Using transactions for single atomic statement
    Order.transaction do
      order = Order.new(order_params.slice('employee_id', 'instructions'))
      order.save!

      # ? Assumption - Frontend ensures that only valid quantity is allowed to place

      # Create individual entry for all items in order
      items.each do |item|
        # set order id for items to link
        item[:order_id] = order.id

        order_item = OrderItem.new(item)
        order_items.push(order_item)

        # reduce quantity of item from inventory
        inventory = Inventory.find_by_item_id(item[:item_id])
        inventory[:stock] = inventory[:stock] - item[:quantity]

        order_item.save!
        inventory.save!

        # fetch preparation time for this item
        item_prep_details = Item.find(item[:item_id])['preparation_details']
        hr = JSON.parse(item_prep_details)['hr']
        min = JSON.parse(item_prep_details)['min']
        sec = JSON.parse(item_prep_details)['sec']
        item_prep_time = 3600 * hr + 60 * min + sec

        # update order preparation time to max of all item prep time
        order_prep_time = [order_prep_time, item_prep_time].max
      end
    end

    # Send notification to user using notification service
    user_id = User.find_by_token(request.cookies['token'])[:employee_id]
    NotificationService.send(order.id, user_id, order_prep_time)

    # return both order as well as items for frontend
    render json: { order: order, items: order_items }, status: :created
  end

  # Route to update status of delivered order
  def update
    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    order = Order.find(params[:id])

    if order.delivered!
      render json: order, status: :ok
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  # Route to remove a placed order
  def destroy
    # * Task - Add status active or cancelled for orders (instead of deleting)

    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    order = Order.find(params[:id])

    if order.cancelled!
      render json: order, status: :ok
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.permit(:employee_id, :instructions, items: %i[item_id quantity])
  end
end
