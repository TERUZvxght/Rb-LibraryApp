class RemoveImgLinkFromBook < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :img_link, :string
  end
end
