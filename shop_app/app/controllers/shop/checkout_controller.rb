class Shop::CheckoutController < BaseController
  layout 'customer'
  before_action :load_service
  protect_from_forgery except: [:hook]
  
  def create
    @transaction = @service_checkout.checkout
    redirect_to @transaction.paypal_url(checkout_path(@transaction))
  end

  def new
    @transaction = Transaction.new
  end

  def show
    @order_items = @service_checkout.load_order
    @transaction = @service_checkout.load_transaction
    @customer    = @service_checkout.load_customer
    @total_price = @transaction.amount
  end

  def hook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      @registration = Transaction.find_by(id: params[:invoice])
      @registration.update_attributes notification_params: params, status_paypal: status, 
                                      checkout_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end
  private
    def load_service
      @service_checkout = CheckoutServices.new(params, @service_user.current_user, 
                                               load_cart, @total, session)
    end
end
