class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :user_uuid, null: false, limit: 36
      t.string :user_name, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :users, :user_uuid, unique: true
    add_index :users, :user_name, unique: true
  end
end
