class ChangeTeaTemperatureToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :teas, :temperature, :float
  end
end
