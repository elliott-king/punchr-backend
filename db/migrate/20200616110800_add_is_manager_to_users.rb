class AddIsManagerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_manager, :boolean, default: false
    remove_column :users, :type, :string
  end
end
