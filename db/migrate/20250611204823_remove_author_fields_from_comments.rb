class RemoveAuthorFieldsFromComments < ActiveRecord::Migration[8.0]
  def change
    remove_column :comments, :author_name, :string
    remove_column :comments, :author_email, :string
  end
end
