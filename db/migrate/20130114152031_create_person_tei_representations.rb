class CreatePersonTeiRepresentations < ActiveRecord::Migration
  def change
    create_table :person_tei_representations do |t|

      t.timestamps
    end
  end
end
