class Refund < ApplicationRecord
  enum :status, {'pending': 0, 'failed': 1, 'successful': 2 }

  belongs_to :order
end
