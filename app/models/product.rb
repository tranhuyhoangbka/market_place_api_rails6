class Product < ApplicationRecord
  validates :title, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}

  belongs_to :user

  scope :filer_by_title, ->(keyword) do
    where('lower(title) LIKE ?', "%#{keyword.downcase}%")
  end

  scope :above_or_equal_to_price, ->(price) {where('price >= ?', price)}
  scope :below_or_equal_to_price, ->(price) {where('price <= ?', price)}
  scope :recent, ->{order(:updated_at)}
end
