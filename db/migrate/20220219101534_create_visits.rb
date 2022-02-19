class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.date :data
      t.string :status
      t.datetime :checkin_at
      t.datetime :checkout_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
