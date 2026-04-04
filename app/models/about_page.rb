class AboutPage < ApplicationRecord
  belongs_to :admin_user
  # title (string)
  validates :title, presence: true,
                    length:   { minimum: 3, maximum: 100 }

  # about (text)
  validates :about, presence: true,
                    length:   { minimum: 10 }

  # contact (text)
  validates :contact, presence: true,
                      length:   { minimum: 10 }

  # admin_user_id (integer FK)
  validates :admin_user_id, presence:     true,
                            numericality: { only_integer: true }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "about", "contact", "admin_user_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["admin_user"]
  end
end
