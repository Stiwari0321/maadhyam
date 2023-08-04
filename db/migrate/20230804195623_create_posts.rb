class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :topic
      t.string :featured_image
      t.text :text
      t.datetime :published_at
      t.string :author

      t.timestamps
    end
  end
end
