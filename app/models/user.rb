class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province
  has_many :orders

  # first_name / last_name (string)
  validates :first_name, presence: true,
                         length: { minimum: 2, maximum: 50 }

  validates :last_name, presence: true,
                        length: { minimum: 2, maximum: 50 }

  # address (string)
  validates :address, presence: true,
                      length: { minimum: 5 }

  # city (string)
  validates :city, presence: true

  # postal_code (string)
  validates :postal_code, presence: true,
                          format: { with: /\A[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d\z/,
                                    message: "invalid Canadian postal code" }

  # province_id (integer FK)
  validates :province_id, presence: true,
                          numericality: { only_integer: true }
end
