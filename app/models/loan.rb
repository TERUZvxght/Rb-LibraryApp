class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book

  def overdue?
    !returned && due_on < Date.today
  end
end
