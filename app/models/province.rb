class Province < ApplicationRecord
  has_many :users
  has_many :orders
  # name
  validates :name, presence: true,
                   length: { minimum: 2, maximum: 50 }

  # code (MB, ON, etc.)
  validates :code, presence: true,
                   length: { is: 2 },
                   uniqueness: true

  # gst / pst / hst（decimal）
  validates :gst, presence: true,
                  numericality: { greater_than_or_equal_to: 0 }

  validates :pst, presence: true,
                  numericality: { greater_than_or_equal_to: 0 }

  validates :hst, presence: true,
                  numericality: { greater_than_or_equal_to: 0 }
end
