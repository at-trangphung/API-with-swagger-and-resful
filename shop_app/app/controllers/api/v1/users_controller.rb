module Api::V1
  class UsersController < ApiController
    before_action :set_user, only: [:update, :destroy]
    before_action :authorization, only: [:index, :destroy, :show]
    # GET /v1/users
    def index
      render json: User.all
    end

    def show
      if payload.present?
        id = Customer.find_by(user_id: payload[0]['user_id'])
        @orders = Transaction.where(customer_id: id).order(created_at: :desc)
        render json: @orders
        return
      else
       render json: { message: "Unauthorized!" }
       return
      end

      @user = User.find(params[:id])
      if @user.present?
        render json: @user
      else
        render json: { message: "User can't be found!" }
      end
    end

    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        @user.send_activation_email
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if params[:password]
        forget_password
        return
      end

      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      logout
      render json: {status: 'User logged successfully'}, status: :ok
    end

    def login
      @user = User.find_by_email(params.require(:user)[:email])
      if @user && @user.authenticate(params.require(:user)[:password])
        if @user.activated_at?
          auth_token = JsonWebToken.encode({user_id: @user.id})
          @user.update_attribute(:remember_digest, auth_token)
          render json: {auth_token: auth_token, 'logged_in' => true}, status: :ok
        else
          render json: {error: 'Email not verified' }, status: :unauthorized
        end
      else
        render json: {error: 'Invalid username / password'}, status: :unauthorized
      end
    end


    def confirm
      token = params[:Token].to_s
      @user = User.find_by(activation_digest: token)
      if @user.present? && @user.confirmation_token_valid?
        @user.mark_as_confirmed!
        render json: {status: 'User confirmed successfully'}, status: :ok
      else
        render json: {status: 'Invalid token'}, status: :not_found
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      def forget_password
        if( @user.update_attribute(:password, params[:password]) && 
          @user.update_attribute(:password_confirmation, params[:password_confirmation]) )
          render json: {status: 'User change password successfully'}, status: :ok
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end

      def logout
        @user.update_attribute(:remember_digest, nil)
      end
  end
end
