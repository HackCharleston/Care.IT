class TransfersController < ApplicationController
  def create
    @user = User.find params[:transfer][:user_id]
    @merchant = Merchant.find_by(:devise => params[:transfer][:devise_id])
    @angel = Angel.find_by(:devise => 'angel') # for the demo, hardcoded the first angel
    amount = params[:transfer][:amount].to_f

    if @user.rule == "Round off to next dollar"
      charge = amount.ceil
    elsif @user.rule == "Round upto next nearest $2"
      charge = amount.ceil + 1
    else
      charge = amount.ceil + 2
    end

    total_charge = charge * 100
    merchant_amount = (amount * 100).round(2).to_i
    angel_amount = (total_charge - merchant_amount).to_i

    # Charge User:

    Stripe::Charge.create(
      :amount => total_charge,
      :currency => "usd",
      :customer => @user.token,
      :description => "Charge for #{@merchant.name}"
    )

    # Transfer to Merchant:

    mtransfer = Stripe::Transfer.create(
      :amount => merchant_amount,
      :currency => "usd",
      :recipient => @merchant.token,
      :statement_description => "Customer Payment: #{@user.first_name}"
    )

    # Transfer to Angel:

    angel_amount = 1 if angel_amount == 0
    atransfer = Stripe::Transfer.create(
      :amount => angel_amount,
      :currency => "usd",
      :recipient => @angel.token,
      :statement_description => "Angel Payment By: #{@user.first_name}"
    )

    @transfer = Transfer.new
    @transfer.merchant_transfer = merchant_amount.to_f/100
    @transfer.angel_transfer = angel_amount.to_f/100
    @transfer.total = total_charge.to_f/100
    @transfer.angel_id = @angel.id
    @transfer.merchant_id = @merchant.id
    @transfer.user_id = @user.id

    if @transfer.save
      data = {response: 'success', angel: @transfer.angel_transfer, merchant: @transfer.merchant_transfer, total: @transfer.total, errors: ''}
      render json: data, status: :created, location: @transfer
    else
      data = {response: 'error', errors: @transfer.errors.to_a.join(', ')}
      render json: data, status: :unprocessable_entity
    end
  end
end
