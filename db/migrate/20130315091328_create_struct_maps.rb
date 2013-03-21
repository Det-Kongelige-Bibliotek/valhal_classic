class CreateStructMaps < ActiveRecord::Migration
  def change
    create_table :struct_maps do |t|

      t.timestamps
    end
  end
end
