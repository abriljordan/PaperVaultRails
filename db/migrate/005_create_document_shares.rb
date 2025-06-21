class CreateDocumentShares < ActiveRecord::Migration[8.0]
  def change
    create_table :document_shares do |t|
      t.references :document, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :shared_by, null: false, foreign_key: { to_table: :users }
      t.string :permission, default: 'view'
      t.datetime :shared_at, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps null: false
    end

    add_index :document_shares, [:document_id, :user_id], unique: true
    add_index :document_shares, :permission
  end
end 