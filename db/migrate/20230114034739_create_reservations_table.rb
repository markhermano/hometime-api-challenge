class CreateReservationsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :code, unique: true, index: true, null: false
      t.datetime :start_date
      t.datetime :end_date
      t.string :currency
      t.integer :payout_price
      t.integer :security_price
      t.integer :total_price
      t.integer :number_of_nights
      t.integer :number_of_guests
      t.text :guest_details
      t.string :status
      t.timestamps

      t.references :guest, index: true, foreign_key: { on_delete: :cascade }
    end
  end
end
