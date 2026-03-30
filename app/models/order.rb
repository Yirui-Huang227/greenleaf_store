class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province, class_name: "Province", foreign_key: "order_province_id"

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  VALID_POSTAL_CODE_REGEX = /\A[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d\z/i
  STATUSES = %w[pending paid shipped cancelled].freeze

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :order_province_id, presence: true, numericality: { only_integer: true }

  validates :order_address, presence: true, length: { maximum: 255 }
  validates :order_city, presence: true, length: { maximum: 100 }
  validates :order_postal_code, presence: true, format: { with: VALID_POSTAL_CODE_REGEX }

  validates :status, presence: true, inclusion: { in: STATUSES }

  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  validates :gst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :stripe_payment_id, length: { maximum: 255 }, allow_blank: true

  def tax_total
    gst_amount.to_f + pst_amount.to_f + hst_amount.to_f
  end
end
