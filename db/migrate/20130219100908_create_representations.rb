class CreateRepresentations < ActiveRecord::Migration
  def change
    create_table :representations do |t|

      t.timestamps
    end
  end
end
