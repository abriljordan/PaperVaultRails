class FolderShare < ApplicationRecord
  belongs_to :folder
  belongs_to :user
  belongs_to :shared_by, class_name: 'User'

  validates :folder_id, uniqueness: { scope: :user_id }
  validates :permission, inclusion: { in: %w[view edit] }

  scope :view_permission, -> { where(permission: 'view') }
  scope :edit_permission, -> { where(permission: 'edit') }

  def can_edit?
    permission == 'edit'
  end

  def can_view?
    true # All shares allow viewing
  end
end 