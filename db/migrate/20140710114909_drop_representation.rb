class DropRepresentation < ActiveRecord::Migration
  def up
    drop_table :representations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
