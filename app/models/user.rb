class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :folders, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :shared_folders, class_name: 'Folder', foreign_key: 'shared_by'
  has_many :shared_documents, class_name: 'Document', foreign_key: 'shared_by'

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def total_storage_used
    documents.sum(:file_size)
  end

  def storage_limit
    5.gigabytes # 5GB free tier
  end

  def storage_remaining
    storage_limit - total_storage_used
  end

  def can_upload?(file_size)
    total_storage_used + file_size <= storage_limit
  end
end 