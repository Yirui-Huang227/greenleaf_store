class Province < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
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

  def self.ransackable_attributes(auth_object = nil)
    ["code", "created_at", "gst", "hst", "id", "id_value", "name", "pst", "updated_at"]
  end
end
