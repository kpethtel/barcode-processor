class CreateBarcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :barcodes do |t|
      t.string :ean8, null: false
      t.string :source

      t.timestamps
    end
    add_index :barcodes, :ean8, unique: true
  end
end
