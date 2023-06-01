class Deal < ApplicationRecord
  has_many :deal_images, dependent: :delete_all
  accepts_nested_attributes_for :deal_images, allow_destroy: true, reject_if: proc { |attributes| attributes[:image].blank? }

  validates :title, :description, :price, :cents, :discount_cents, :quantity, :deals_tax, presence: true

  validates_with PublishDateValidator

  validates :scheduled_deals_count, numericality: { less_than: 2, message: "No more than 2 deals can be published in one day" }, unless: :published_date

  validates :discount_cents, numericality: { less_than_equal_to: :cents }

  with_options if: :publishable? do
    validates :quantity, numericality: { greater_than: 10, message: ' should be greater than 10' }
    validates :images_count, numericality: { greater_than: 1, message: 'should be greater than 2' }
    validates :deals_tax, numericality: { in: 0..28 }, allow_blank: true
  end

  after_save :check_publishablity

  scope :publishable_on, ->(date) { where(publish_date: date) }

  def images_count
    deal_images.count
  end

  def price_in_decimal(price, cents)
    cents/price
  end

  def scheduled_deals_count
    self.class.publishable_on(self.publish_date).size
  end

  def check_publishablity
    self.publishable = true
    valid?
  end
end
