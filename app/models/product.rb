class Product < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
end
