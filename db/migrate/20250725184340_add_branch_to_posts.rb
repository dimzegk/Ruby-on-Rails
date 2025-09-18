class AddBranchToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :branch, :string
  end
end
