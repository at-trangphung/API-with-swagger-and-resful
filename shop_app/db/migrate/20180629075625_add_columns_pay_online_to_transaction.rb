class AddColumnsPayOnlineToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :notification_params, :text
    add_column :transactions, :status_paypal, :string
    add_column :transactions, :checkout_id, :string
    add_column :transactions, :purchased_at, :datetime
  end
end
