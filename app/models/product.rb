class Product < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_many :order_items

  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "description", "price", "on_sale", "quantity", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories", "categorizations"]
  end

  scope :on_sale, -> { where(on_sale: true) }
  scope :new_arrivals, -> { where("created_at >= ?", 3.days.ago) }
  scope :recently_updated, -> { order(updated_at: :desc) }
end
