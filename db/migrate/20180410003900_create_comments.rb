class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content
      t.text :title

      t.timestamps null: false
    end
  end
end
