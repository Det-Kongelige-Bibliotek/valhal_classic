class DropSingleFileRepresentation < ActiveRecord::Migration
  def up
    drop_table :single_file_representations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
