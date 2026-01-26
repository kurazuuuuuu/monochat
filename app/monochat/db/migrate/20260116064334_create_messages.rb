class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.string :message_uuid, null: false, limit: 36
      t.string :sender_uuid, null: false, limit: 36
      t.string :space_uuid, null: false, limit: 36
      t.text :content, null: false

      t.timestamps
    end

    add_index :messages, :message_uuid, unique: true
    add_index :messages, :sender_uuid
    add_index :messages, :space_uuid
    add_index :messages, :created_at
  end
end
