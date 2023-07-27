class InventoriesController < ApplicationController
  def index
    @inventories = Inventory.all
  end

  def show
    @inventory = Inventory.includes(inventory_foods: :food).find(params[:id])
    @inventory_id = @inventory.id
    @inventory_food = @inventory.inventory_foods
  end

  def destroy
    @inventory = Inventory.find(params[:id])

    if @inventory.destroy
      flash[:notice] = 'Inventory deleted successfully!'
      redirect_to inventories_path
    else
      flash[:alert] = 'Failed to delete the inventory. Please try again.'
      redirect_to inventory_path(@inventory)
    end
  end

  def new
    @new_inventory = Inventory.new
  end

  def create
    inventory = Inventory.new(user: current_user, name: params[:inventory][:name])
    respond_to do |format|
      if inventory.save
        flash[:notice] = 'Created an inventory succesfully'
        format.html { redirect_to '/inventories' }
      else
        flash[:notice] = 'Failed to create an inventory. Try again'
        format.html { redirect_to '/inventories/new' }
      end
    end
  end
end
