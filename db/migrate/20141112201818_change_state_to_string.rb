class ChangeStateToString < ActiveRecord::Migration
  def change
    change_column :addresses, :state, :string
    change_column :mail_addresses, :state, :string
  end
end
