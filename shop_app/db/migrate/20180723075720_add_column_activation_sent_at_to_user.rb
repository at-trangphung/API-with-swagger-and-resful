class AddColumnActivationSentAtToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :activation_sent_at, :datetime
  end
end
