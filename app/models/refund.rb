class Refund < ApplicationRecord
  enum :status, {'Pending': 0, 'Failed': 1, 'Successful': 2 }

  belongs_to :order
  
  scope :successful, ->{ where(status: 'Successful').first }
end
