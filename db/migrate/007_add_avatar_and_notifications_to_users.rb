class AddAvatarAndNotificationsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notify_on_share, :boolean, default: true
    add_column :users, :notify_on_comment, :boolean, default: true
    # Avatar is handled by Active Storage, no column needed
  end
end 