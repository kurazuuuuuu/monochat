class CreateSpaces < ActiveRecord::Migration[8.1]
  def change
    create_table :spaces do |t|
      t.string :space_uuid, null: false, limit: 36
      t.string :space_name, null: false

      t.timestamps
    end

    add_index :spaces, :space_uuid, unique: true
  end
end
