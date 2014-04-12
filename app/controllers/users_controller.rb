class UsersController < ApplicationController
  def index
    if params[:name]
      first_name = params[:name].split(' ').first
      last_name = params[:name].split(' ').last
      @user = User.where(:first_name => first_name, :last_name => last_name).first

      if @user
        data = {
          response: 'success',
          id: @user.id.to_s,
          response: 'success',
          name: @user.first_name + " " + @user.last_name,
          image_url: @user.avatar.url,
          rules: @user.rule,
          email: @user.email,
          errors: ''
        }
      else
        data = {
          response: 'error',
          errors: 'No user found'
        }
      end
    elsif params[:finger_id]
      @user = User.where(:finger_id => params[:finger_id]).first

      if @user
        data = {
          response: 'success',
          id: @user.id.to_s,
          response: 'success',
          name: @user.first_name + " " + @user.last_name,
          image_url: @user.avatar.url,
          rules: @user.rule,
          email: @user.email,
          errors: ''
        }
      else
        data = {
          response: 'error',
          errors: 'No user found'
        }
      end
    else
        data = {
          response: 'error',
          errors: 'No name mentioned'
        }
    end

    render json: data
  end

  def create
    avatar = params[:user][:avatar]

    # TODO: Change it to real payment instructions after testing
    stripe = Stripe::Customer.create(
      :email => params[:user][:email],
      :card => {
        :number => "4242424242424242",#params[:user][:card],
        :cvc => "123", #params[:user][:cvv],
        :exp_month => "10", #params[:user][:expiry].split('-').first,
        :exp_year => "2015", #params[:user][:expiry].split('-').last
      }
    )

    params[:user].delete :avatar
    params[:user].delete :card
    params[:user].delete :cvv
    params[:user].delete :expiry

    @user = User.new(params[:user])
    @user.token = stripe.id
    @user.card_token = stripe.default_card

    # Decode and save to AWS
    decoded_data = Base64.decode64(avatar)
    data = StringIO.new(decoded_data)
    # data.content_type = 'image/png'
    # data.original_filename = "avatar.png"
    @user.avatar = data

    if @user.save
      data = {response: "success", image: @user.avatar.url, errors: ''}
      render json: data, status: :created, location: @user
    else
      data = {response: "error", errors: @user.errors.to_a.join(', ')}
      render json: data, status: :unprocessable_entity
    end
  end
end
