class LineItem < ApplicationRecord
  belongs_to :deal
  belongs_to :order

  def unit_price
    discount_price_in_cents + tax_on_deal
  end

  def total_price
    unit_price * quantity 
  end

  def tax_on_deal
    deal.deals_tax  * discount_price_in_cents * 0.01
  end
end
