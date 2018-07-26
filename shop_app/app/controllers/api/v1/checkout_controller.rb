module Api::V1
  class CheckoutController < ApiController

    def create
      @transaction = checkout_api
      
      if @transaction
        render json: @transaction, status: :created, location: @transaction
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end

    def show
      transaction = Transaction.find(params[:id])
      if transaction.present?
        render json: transaction
      else
        render json: { message: "Transaction can't be found!" }
      end
    end

    private

      def checkout_api
        @customer = Customer.new(customer_params_api)
        @check_user =  User.find_by(email: @customer.email)

        if @check_user
          @user_customer = Customer.find_by(email: @check_user.email)
          if @user_customer
            @transaction = create_transaction_api
            @transaction.customer_id = @user_customer.id
            @transaction.amount = params[:transaction][:amount]
          else
            @customer.user_id = @check_user.id
            @customer.save! 
            @transaction = create_transaction_api
            @transaction.customer_id = @customer.id
            @transaction.amount = params[:transaction][:amount]
          end
        else
          @new_user = create_new_user_api
          @customer.user_id = @new_user.id
          @customer.save! 
          @transaction = create_transaction_api
          @transaction.customer_id = @customer.id
          @transaction.amount = params[:transaction][:amount]
        end

        if @transaction.save!
          # @order_items.each do |order_detail|
          #   order_detail.transaction_id = @transaction.id
          #   order_detail.save
          # end
          @order = Order.new(order_params_api)
          @order.transaction_id = @transaction.id
          @order.save!
          if @new_user
            UserMailer.new_user_checkout(@new_user).deliver_now
          end
          @transaction.send_check_order_email
        end
        @transaction
      end

      def create_transaction_api
        @transaction = Transaction.new
        @transaction.created = Time.now
        @transaction.receiver = customer_params_api["last_name"]
        @transaction.phone_rec = customer_params_api["phone"]
        @transaction.address_deliver_rec = customer_params_api["address_deliver"]
        hours_delivery = params[:transaction][:hours]
        minutes_delivery = params[:transaction][:minutes]
        @transaction.comment = params[:transaction][:comment]
        if ( hours_delivery.blank? && minutes_delivery.blank? )
          @transaction.delivery_time = Time.zone.now
        else
          @transaction.delivery_time = Time.zone.now + hours_delivery.to_i.hours 
                                                     + minutes_delivery.to_i.minutes
        end
        @transaction
      end

      def create_new_user_api
        @new_user = User.new
        @new_user.password = "Thuanhieu123"
        @new_user.first_name = customer_params_api[:first_name]
        @new_user.last_name = customer_params_api[:last_name]
        @new_user.email = customer_params_api[:email]
        @new_user.address = customer_params_api[:address]
        @new_user.address_deliver = customer_params_api[:address_deliver]
        @new_user.company = customer_params_api[:company]
        @new_user.phone = customer_params_api[:phone]
        @new_user.save!
        @new_user
      end

      def customer_params_api
        params.require(:customer)
              .permit(
                :first_name, :last_name, :email, :company, :address, :address_deliver, :phone
              )
      end

      def order_params_api
        params.require(:order)
              .permit(
                :product_id, :quantity, :total_payment, :price, :size, :type
              )
      end
  end
end