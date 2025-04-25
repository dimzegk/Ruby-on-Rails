class AddUserAndCategoryToPosts < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :user, null: false, foreign_key: true
    add_reference :posts, :category, null: false, foreign_key: true
  end
end
