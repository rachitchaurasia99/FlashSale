class Deal < ApplicationRecord
  include ActiveModel::Serialization

  has_many :deal_images, dependent: :delete_all
  has_many :line_items, dependent: :restrict_with_exception
  has_many :orders, through: :line_items

  accepts_nested_attributes_for :deal_images, allow_destroy: true, reject_if: proc { |attributes| attributes[:image].blank? }

  validates :title, :description, :price_in_cents, :discount_price_in_cents, :quantity, :deals_tax, presence: true

  validate :valid_publish_date?

  validates :scheduled_deals_count, numericality: { less_than: 2, message: "No more than 2 deals can be published in one day" }, unless: :published_date

  validates :discount_price_in_cents, numericality: { less_than_equal_to: :price_in_cents }

  with_options if: :published_date? do
    validates :quantity, numericality: { greater_than: 10, message: ' should be greater than 10' }
    validates :images_count, numericality: { greater_than: 1, message: 'should be greater than 2' }
    validates :deals_tax, numericality: { in: 0..28 }, allow_blank: true
  end

  scope :live, ->{ where(publishable: true).where.not(published_date: nil) }
  scope :expired, ->{ where(publishable: false).where.not(published_date: nil) }
  scope :publishable_on, ->(date) { where(publish_date: date) }
  scope :to_publish, ->{ where(publish_date: Date.current).where(published_date: nil).where(publishable: true) }
  scope :to_unpublish, ->{ where(publish_date: Date.current).where.not(published_date: nil).where(publishable: true) }
  scope :delivered_orders, ->{ includes(:orders).where(orders: {status: 'Delivered'})}

  def images_count
    deal_images.count
  end

  def scheduled_deals_count
    self.class.publishable_on(self.publish_date).size
  end

  def check_publishablity
    self.publishable = true
    valid?
  end

  def valid_publish_date?
    if publish_date_changed? && publishable && publish_date_was
      unless publish_date_was - Time.current > TWENTY_FOUR_HOURS
        errors.add :base, "Cannot update publish_date 24 hours before deal going live"
      end
    end
  end

  def serialize
    serializable_hash(only: [:id, :title, :description, :quantity, :price_in_cents, :discount_price_in_cents])
  end

  def self.deal_revenue
    deals_with_revenue = {}
    delivered_orders.map{ |deal| deals_with_revenue.store(deal, deal.orders.length * deal.deal_price_with_tax) }
    deals_with_revenue
  end

  def deal_price_with_tax
    discount_price_in_cents + deals_tax  * discount_price_in_cents * 0.01
  end

  def expiring_soon?
    published_date + TWENTY_FOUR_HOURS - Time.current < THIRTY_MINUTES
  end
end
