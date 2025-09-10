class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.date :published_on
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
