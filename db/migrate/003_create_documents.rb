class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :folder, null: true, foreign_key: true
      t.bigint :file_size, default: 0
      t.string :file_type
      t.string :file_extension
      t.boolean :is_starred, default: false
      t.datetime :starred_at
      t.datetime :last_accessed_at
      t.integer :access_count, default: 0

      t.timestamps null: false
    end

    add_index :documents, [:user_id, :folder_id, :name], unique: true
    add_index :documents, :is_starred
    add_index :documents, :file_type
    add_index :documents, :last_accessed_at
  end
end 