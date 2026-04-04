class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :products, through: :categorizations

  # name (string)
  validates :name, presence: true,
                   length:   { minimum: 2, maximum: 100 }

  # description (text)
  validates :description, presence: true,
                          length:   { minimum: 5 }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categorizations", "products"]
  end
end
