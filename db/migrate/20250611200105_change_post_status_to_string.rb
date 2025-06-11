class ChangePostStatusToString < ActiveRecord::Migration[8.0]
  def up
    change_column :posts, :status, :string
  end

  def down
    change_column :posts, :status, :integer
  end
end
