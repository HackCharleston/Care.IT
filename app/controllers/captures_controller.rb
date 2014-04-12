class CapturesController < ApplicationController
  def create
    if params[:capture]
      avatar = params[:capture][:avatar]
      params[:capture].delete :avatar
      @capture = Capture.new(params[:capture])

      # Decode and save to AWS
      decoded_data = Base64.decode64(avatar)
      data = StringIO.new(decoded_data)
      @capture.avatar = data

      if @capture.save
        data = {response: "success", errors: 'success' }
        render json: data, status: :created, location: @capture
      else
        data = {response: "error", errors: @capture.errors.join(', ') }
        render json: data, status: :unprocessable_entity  
      end
    else
      data = {response: "error", errors: 'No Data' }
      render json: data, status: :unprocessable_entity
    end
  end
end