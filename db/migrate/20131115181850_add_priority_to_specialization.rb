class AddPriorityToSpecialization < ActiveRecord::Migration
  def change
    add_column :specializations, :priority, :integer, :default => 0
  end
end
