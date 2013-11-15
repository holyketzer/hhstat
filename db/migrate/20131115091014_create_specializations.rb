class CreateSpecializations < ActiveRecord::Migration
  def change
    create_table :specializations do |t|
      t.string :name
      t.string :keywords

      t.timestamps
    end
  end
end
