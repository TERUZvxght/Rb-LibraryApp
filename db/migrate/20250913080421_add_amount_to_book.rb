class AddAmountToBook < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :amount, :integer
  end
end
