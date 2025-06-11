class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.string :author_name
      t.string :author_email
      t.text :content
      t.boolean :approved

      t.timestamps
    end
  end
end
