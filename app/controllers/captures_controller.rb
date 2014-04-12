class CapturesController < ApplicationController
  def create
    if params[:capture]
      avatar = params[:capture][:avatar]
      params[:capture].delete :avatar
      @capture = Capture.new(params[:capture])

      if avatar
        # Decode and save to AWS
        decoded_data = Base64.decode64(avatar)
        data = StringIO.new(decoded_data)
        @capture.avatar = data
      end

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

  def todays
    result = (0.Capture.count-1).sort_by{rand}.slice(0, 1).collect! do |i| Capture.skip(i).first end
    data = {response: 'success', errors: '', value: result.first.avatar.url}
    render json: data
  end
end