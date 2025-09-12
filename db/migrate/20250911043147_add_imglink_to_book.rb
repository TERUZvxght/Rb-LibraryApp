class AddImglinkToBook < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :img_link, :string
  end
end
