class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    return head(:forbidden) unless user.authenticate(params[:password])

    token = encodeJWTToken(user_id: user.id)
    time = Time.now + 24.hours.to_i

    render json: { user: user.as_json(except: [:password_digest]), token: token, exp: time.strftime("%m-%d-%Y %H:%M")}, status: :ok
  end
end