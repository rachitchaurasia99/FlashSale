class Payment < ApplicationRecord
  enum :status, {'Pending': 0, 'Failed': 1, 'Successful': 2 }
end
