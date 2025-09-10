json.extract! loan, :id, :user_id, :book_id, :borrowed_on, :due_on, :returned, :created_at, :updated_at
json.url loan_url(loan, format: :json)
