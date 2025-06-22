class Document < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  has_one_attached :file
  has_many :document_shares, dependent: :destroy
  has_many :shared_users, through: :document_shares, source: :user

  validates :file, presence: true
  validate :file_size_limit
  validate :file_type_allowed

  scope :recent, -> { order(created_at: :desc) }
  scope :shared_with, ->(user) { joins(:document_shares).where(document_shares: { user: user }) }
  scope :starred, -> { where(is_starred: true) }

  before_save :set_name_from_file
  before_save :set_file_size
  before_save :set_file_type
  before_save :ensure_name_uniqueness

  def file_size
    file.attached? ? file.byte_size : 0
  end

  def file_extension
    File.extname(name).downcase
  end

  def is_image?
    file.content_type.start_with?('image/')
  end

  def is_pdf?
    file.content_type == 'application/pdf'
  end

  def is_document?
    %w[application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document].include?(file.content_type)
  end

  def is_spreadsheet?
    %w[application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet].include?(file.content_type)
  end

  def is_presentation?
    %w[application/vnd.ms-powerpoint application/vnd.openxmlformats-officedocument.presentationml.presentation].include?(file.content_type)
  end

  def is_shared?
    document_shares.exists?
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

  private

  def set_name_from_file
    if file.attached? && (name.blank? || name == file.filename.to_s)
      self.name = file.filename.to_s
    end
  end

  def set_file_size
    self.file_size = file.byte_size if file.attached?
  end

  def set_file_type
    self.file_type = file.content_type if file.attached?
  end

  def ensure_name_uniqueness
    return unless name.present?
    
    base_name = name
    extension = File.extname(name)
    name_without_extension = File.basename(name, extension)
    counter = 1
    
    while Document.where(user: user, folder: folder, name: name).where.not(id: id).exists?
      name = "#{name_without_extension} (#{counter})#{extension}"
      counter += 1
    end
  end

  def file_size_limit
    return unless file.attached?
    
    max_size = 100.megabytes
    if file.byte_size > max_size
      errors.add(:file, "size must be less than #{max_size / 1.megabyte}MB")
    end
  end

  def file_type_allowed
    return unless file.attached?
    
    allowed_types = [
      'image/jpeg', 'image/png', 'image/gif', 'image/webp',
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.ms-powerpoint',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'text/plain',
      'text/csv',
      'application/zip',
      'application/x-zip-compressed'
    ]
    
    unless allowed_types.include?(file.content_type)
      errors.add(:file, 'type not allowed')
    end
  end
end 