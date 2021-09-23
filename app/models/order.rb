class Order < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  validates_with EnoughProductsValidator

  before_validation :set_total!

  def set_total!
    self.total = products.map(&:price).sum
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    # example product_ids_and_quantities = [{product_id: 1, quantity: 2}]
    product_ids_and_quantities.each do |product_ids_and_quantitie|
      placement = placements.build(product_id: product_ids_and_quantitie[:product_id], quantity: product_ids_and_quantitie[:quantity])
      yield(placement) if block_given?
    end
  end
end
