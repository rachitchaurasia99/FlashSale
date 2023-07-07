class Currency < ApplicationRecord
  before_save :set_date

  scope :current_rate, ->{ order(:name).where('DATE(created_at) = ?', Date.current) }

  def set_date
    self.date = Date.current
  end

  def self.rate_on(name, date)
    find_by(name: name, date: date).conversion_rate
  end
end
