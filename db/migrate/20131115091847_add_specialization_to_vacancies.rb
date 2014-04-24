class AddSpecializationToVacancies < ActiveRecord::Migration
  def change
    change_table :vacancies do |t|
      t.integer :specialization_id
    end
  end
end
