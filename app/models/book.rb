class Book < ApplicationRecord
  belongs_to :author
  has_many :loans
  has_one_attached :cover, dependent: :destroy_async
end
