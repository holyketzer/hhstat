class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :code
      t.string :name
      t.float :rate

      t.timestamps
    end
  end
end
