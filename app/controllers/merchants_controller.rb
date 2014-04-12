class MerchantsController < ApplicationController
  def create
    @merchant = Merchant.new(params[:merchant])

    stripe = Stripe::Recipient.create(
      :name => @merchant.name,
      :email => @merchant.email,
      :type => "individual",
      :tax_id => "000000000",#@merchant.tax_id,
      :bank_account => {
        :country => "US",
        :routing_number => "110000000", #@merchant.routing_no,
        :account_number => "000123456789" #@merchant.acc_no
      }
    )

    @merchant.token = stripe.id

    if @merchant.save
      data = {response: "success", errors: '' }
      render json: data, status: :created, location: @merchant
    else
      data = {response: "error", errors: @merchant.errors.to_a.join(', ') }
      render json: data, status: :unprocessable_entity
    end
  end

  def index
    # Considering only 1 angel for the demo
    value = Angel.first.transfers.sum{|a| a.angel_transfer.to_f}.to_s.rjust(7, '0')
    data = {response: "success", errors: '', value: value }
    render json: data
  end
end
