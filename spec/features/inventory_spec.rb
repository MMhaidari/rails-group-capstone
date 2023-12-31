require 'rails_helper'

RSpec.describe 'Inventories', type: :feature do
  let!(:user) { User.create(name: 'Test', email: 'test2@example.com', password: 'password') }
  let!(:inventory) do
    inventory = Inventory.new(name: 'Inventory 1')
    inventory.user = user
    inventory.save!
    inventory
  end

  before do
    # Log in the user before each test
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit new_inventory_path
    # Create the inventory
    @inventory = Inventory.create(name: 'Inventory 1')

    # Find the inventory by name
    @inventory = Inventory.find_by(name: 'Inventory 1')
    fill_in 'Name', with: 'Inventory 1'
    fill_in 'Name', with: 'Inventory 2'
    click_button 'Create Inventory'

    # Assign the inventory to a variable and save it
    @inventory = Inventory.new(name: 'Inventory 1')
    @inventory = Inventory.new(name: 'Inventory 2')
    @inventory.user = user
    @inventory.save!
  end

  describe 'Inventory index page' do
    before do
      @inventory1 = Inventory.create(name: 'Inventory 1')
      @inventory2 = Inventory.create(name: 'Inventory 2')
      visit '/inventories'
    end

    it 'displays a list of inventories with their names' do
      expect(page).to have_content('Inventory 1')
      expect(page).to have_content('Inventory 2')
    end

    it 'allows logged-in users to delete inventories' do
      expect(page).to have_button('DELETE', count: 3)
    end
  end

  context 'Inventory list is empty' do
    before do
      Inventory.destroy_all
      visit '/inventories'
    end

    it 'displays a message when the inventory list is empty' do
      expect(page).to have_content('Add New Inventory Currently You Do Not Have Any Inventory In The List')
    end
  end

  describe 'New inventory page' do
    it 'redirects to the inventory index page after creating a new inventory' do
      visit new_inventory_path
      fill_in 'Name', with: 'New Inventory'
      click_button 'Create Inventory'
      expect(current_path).to eq(inventories_path)
    end
  end

  describe 'Inventory show page' do
    before do
      @inventory = Inventory.create(name: 'Inventory 1')
      visit inventory_path(@inventory)
    end
  end
end
