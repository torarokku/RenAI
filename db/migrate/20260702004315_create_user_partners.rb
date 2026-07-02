class CreateUserPartners < ActiveRecord::Migration[7.1]
  def change
    create_table :user_partners do |t|
      t.references :user, null: false, foreign_key: true
      t.references :partner, null: false, foreign_key: true
      t.integer :affection
      t.string :status

      t.timestamps
    end
  end
end
