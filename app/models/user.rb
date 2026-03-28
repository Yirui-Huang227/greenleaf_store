class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders

  # first_name / last_name (string)
  # validates :first_name,
                         # length: { minimum: 2, maximum: 50 }

  # validates :last_name,
                        # length: { minimum: 2, maximum: 50 }

  # province
  # validates :province_id,
                          # numericality: { only_integer: true }

  # Address
  validates :address, length: { minimum: 5 }, allow_blank: true
  validates :city, presence: true, if: -> { address.present? }
  validates :postal_code,
            format: { with: /\A[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d\z/ },
            allow_blank: true
end
