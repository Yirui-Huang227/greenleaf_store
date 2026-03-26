class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :products, through: :categorizations

  # name (string)
  validates :name, presence: true,
                   length: { minimum: 2, maximum: 100 }

  # description (text)
  validates :description, presence: true,
                          length: { minimum: 5 }
end
