# Controller to hand Food_Item routes
class FoodItemController < ApplicationController
  # Route to list all items in inventory
  def index
    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    render json: {
      item: Item.all,
      inventory: Inventory.all
    }, status: :ok
  end

  # Route to add an item to inventory
  def create
    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    # Check if item already exists, then no need to create, just update the stock
    item = Item.find_by_name(params[:name])
    item = Item.new(item_params) if item.blank?

    render json: item.errors, status: :unprocessable_entity and return unless item.save

    # Check if item already exists, then no need to create, just update the stock
    inventory = Inventory.find_by_item_id(item.id)
    if inventory.blank?
      inventory = Inventory.new(inventory_params)
    else
      inventory.update(inventory_params)
    end

    # Attached item_id of newly created item to inventory entry
    inventory.item_id = item.id

    if inventory.save
      render json: inventory, status: :created
    else
      render json: inventory.errors, status: :unprocessable_entity
    end
  end

  # Route to delete an item from inventory (not the actual item itself)
  def destroy
    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    Inventory.find(params[:id]).destroy!

    head :no_content
  end

  # Route to update an item from inventory
  def update
    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    inventory = Inventory.find(params[:id])

    if inventory.update(inventory_params)
      render json: inventory, status: :ok
    else
      render json: inventory.errors, status: :unprocessable_entity
    end
  end

  # Route to update rating for an item
  def rating_update
    # Check for user token validity
    check = CheckAuthService.check(request.cookies['token'])
    render status: :unauthorized and return unless check

    rating_params_hash = rating_params.to_h
    item_id = rating_params_hash['item_id']
    rating = rating_params_hash['rating']

    # select item to update its rating
    item = Item.where(id: item_id).first
    curr_rate = item.rating

    # using reviewers count to update rating(average)
    rate_change = (rating - curr_rate) / (item.reviewers + 1.0)
    item.rating = curr_rate + rate_change
    item.reviewers = item.reviewers + 1

    render json: item.errors, status: :unprocessable_entity and return unless item.save

    render json: item, status: :ok
  end

  private

  # function definition for permitting parameters for item creation
  def item_params
    params.require(:food_item).permit(:name, :description, :preparation_details, :rating)
  end

  # function definition for permitting parameters for inventory creation
  def inventory_params
    params.require(:food_item).permit(:stock)
  end

  # function definition for permitting parameters for rating updation
  def rating_params
    params.require(:food_item).permit(:item_id, :rating)
  end
end
