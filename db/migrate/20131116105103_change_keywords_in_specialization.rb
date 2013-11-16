class ChangeKeywordsInSpecialization < ActiveRecord::Migration
  def change
    change_column(:specializations, :keywords, :string, limit: 65535)
  end
end
