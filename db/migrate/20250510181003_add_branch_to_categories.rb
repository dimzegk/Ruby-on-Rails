class AddBranchToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :branch, :string
  end
end
