class Payment < ApplicationRecord
  enum :status, { Pending: 0, Failed: 1, Successful: 2 }

  belongs_to :order
  
  scope :successful, ->{ where(status: :Successful).first }

  def total_amount
    total_amount_in_cents * 0.01
  end
end
