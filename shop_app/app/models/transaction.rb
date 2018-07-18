class Transaction < ApplicationRecord
  has_many :orders
  has_many :products, through: :orders
  enum status: {waiting: 0, accept: 1, reject: 2}
  
  belongs_to :customer
  
  def send_check_order_email
    UserMailer.check_order(self).deliver_now
  end

  def send_new_user_checkout
    UserMailer.new_user_checkout(self).deliver_now
  end

  serialize :notification_params, Hash
  def paypal_url(return_path)
    values = {
        business: "badbyboyxyzkt-facilitator@yahoo.com.vn",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        invoice: id,
        amount: amount,
        item_name: comment,
        item_number: id,
        quantity: '1',
        notify_url: "#{Rails.application.secrets.app_host}/hook"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
  
  def setup!(return_url, cancel_url)
    payment_request = payment_request self.quantity
    response = client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true
    )
    self.token = response.token
    self.save! rescue false
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  def cancel!
    self.canceled = true
    self.save! rescue false
    self
  end

  def complete!(payer_id = nil)
    payment_request = payment_request  self.quantity
    response = client.checkout!(self.token, payer_id, payment_request)
    self.payer_id = payer_id
    self.transaction_id = response.payment_info.first.transaction_id
    self.status = "completed"
    self.purchased_at = Time.now
    #TODO calculate expires_at

    self.save! rescue false
    self
  end
end
