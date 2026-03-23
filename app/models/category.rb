class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories

  # name (string)
  validates :name, presence: true,
                   length: { minimum: 2, maximum: 100 }

  # description (text)
  validates :description, presence: true,
                          length: { minimum: 5 }
end
