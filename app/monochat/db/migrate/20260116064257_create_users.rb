class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.uuid :user_uuid, null: false
      t.string :user_name, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :users, :user_uuid, unique: true
    add_index :users, :user_name, unique: true
  end
end
