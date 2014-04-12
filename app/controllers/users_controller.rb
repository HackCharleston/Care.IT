class UsersController < ApplicationController
  def index
    if params[:name]
      @user = User.where(:username => params[:name]).first

      unless @user
        @user = User.where(:username => /.*#{params[:name]}*/).first
      end

      if @user
        data = {
          response: 'success',
          id: @user.id.to_s,
          name: @user.first_name + " " + @user.middle_name + " " + @user.last_name,
          username: @user.username,
          image_url: 'https://s3-us-west-2.amazonaws.com/digsouth' + @user.avatar.url.to_s.split('digsouth').last,
          finger: @user.finger,
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
          name: @user.first_name + " " + @user.middle_name + " " + @user.last_name,
          image_url: 'https://s3-us-west-2.amazonaws.com/digsouth' + @user.avatar.url.to_s.split('digsouth').last,
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

  def save_finger
    if params[:user][:name]
      @user = User.where(:username => params[:user][:name]).first
      @user.finger = true #params[:user][:finger]
      @user.save
      data = {response: 'success', errors: ''}
    else
      data = {response: 'error', errors: 'No Username in the request'}
    end
    render json: data
  end

  def create
    logger.info "--------------------->"
    logger.info params
    logger.info "--------------------->"


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
    params[:user].delete :cctype
    params[:user].delete :expiry

    @user = User.new(params[:user])
    @user.username = @user.first_name + @user.middle_name + @user.last_name
    @user.token = stripe.id
    @user.card_token = stripe.default_card

    # Decode and save to AWS
    if avatar
      decoded_data = Base64.decode64(avatar)
      data = StringIO.new(decoded_data)
      # data.content_type = 'image/png'
      # data.original_filename = "avatar.png"
      @user.avatar = data
    end

    if @user.save
      data = {response: "success", image: @user.avatar.url, errors: '', user_id: @user.id.to_s, username: @user.username}
      render json: data, status: :created, location: @user
    else
      data = {response: "error", errors: @user.errors.to_a.join(', ')}
      render json: data, status: :unprocessable_entity
    end
  end
end
