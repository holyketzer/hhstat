class CreateVacancies < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.decimal :salary_from
      t.decimal :salary_to
      t.string :name
      t.integer :area_id
      t.datetime :created
      t.integer :employer_id

      t.timestamps
    end
  end
end
