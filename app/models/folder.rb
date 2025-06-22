class Folder < ApplicationRecord
  acts_as_tree order: 'name'
  
  belongs_to :user
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :children, class_name: 'Folder', foreign_key: 'parent_id', dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :folder_shares, dependent: :destroy
  has_many :shared_users, through: :folder_shares, source: :user

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:user_id, :parent_id] }
  
  scope :root_folders, -> { where(parent_id: nil) }
  scope :shared_with, ->(user) { joins(:folder_shares).where(folder_shares: { user: user }) }
  scope :starred, -> { where(is_starred: true) }

  def full_path
    if parent
      "#{parent.full_path}/#{name}"
    else
      name
    end
  end

  def total_size
    documents.sum(:file_size) + children.sum(&:total_size)
  end

  def document_count
    documents.count + children.sum(&:document_count)
  end

  def is_shared?
    folder_shares.exists?
  end

  def is_starred?
    is_starred
  end

  def can_access?(user)
    user == self.user || shared_users.include?(user)
  end

  def can_edit?(user)
    user == self.user
  end
end 