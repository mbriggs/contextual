class ChangeCommentApprovedToTimestamp < ActiveRecord::Migration[8.0]
  def change
    remove_column :comments, :approved, :boolean
    add_column :comments, :approved_at, :datetime
  end
end
