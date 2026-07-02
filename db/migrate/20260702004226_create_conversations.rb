class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :partner, null: false, foreign_key: true
      t.text :message
      t.string :speaker

      t.timestamps
    end
  end
end
