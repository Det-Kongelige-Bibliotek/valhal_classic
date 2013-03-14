class CreateTiffFiles < ActiveRecord::Migration
  def change
    create_table :tiff_files do |t|

      t.timestamps
    end
  end
end
