class AboutPage < ApplicationRecord
  belongs_to :admin_user
  # title (string)
  validates :title, presence: true,
                    length: { minimum: 3, maximum: 100 }

  # about (text)
  validates :about, presence: true,
                    length: { minimum: 10 }

  # contact (text)
  validates :contact, presence: true,
                      length: { minimum: 10 }

  # admin_user_id (integer FK)
  validates :admin_user_id, presence: true,
                            numericality: { only_integer: true }
end
