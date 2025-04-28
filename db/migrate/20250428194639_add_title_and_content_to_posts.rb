class AddTitleAndContentToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :title, :string
    add_column :posts, :content, :text
  end
end
