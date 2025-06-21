class CreateFolders < ActiveRecord::Migration[8.0]
  def change
    create_table :folders do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :folders }
      t.string :color, default: '#4285f4'
      t.boolean :is_starred, default: false
      t.datetime :starred_at

      t.timestamps null: false
    end

    add_index :folders, [:user_id, :parent_id, :name], unique: true
    add_index :folders, :is_starred
  end
end 