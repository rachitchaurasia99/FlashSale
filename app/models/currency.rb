class Currency < ApplicationRecord
  before_create :set_date

  validate :conversion_rates_presence

  def self.current_rate
    last.conversion_rates
  end

  def set_date
    self.date = Date.current
  end

  def self.rate_on(name, date)
    where(date: ..date).last.conversion_rates[name].to_f
  end

  private

  def conversion_rates_presence
    errors.add(:base, 'Please enter all conversion rates') if conversion_rates.values.any?(&:blank?)
  end
end
