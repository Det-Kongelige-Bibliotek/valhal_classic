class CreateSingleFileRepresentations < ActiveRecord::Migration
  def change
    create_table :single_file_representations do |t|

      t.timestamps
    end
  end
end
