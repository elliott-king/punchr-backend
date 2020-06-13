class AddHourlyWageToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :hourly_wage, :float
  end
end
