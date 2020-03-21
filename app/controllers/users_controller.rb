class UsersController < ApplicationController

  include JsonWebToken
  before_action :jwt_authenticate, except: :create

  def create
    new_user = User.new(user_params)
    begin new_user.save
      render status: 200, json: {status: 200, new_user: new_user}
    rescue
      render status: 400, json: {status: 400, msg: new_user.errors}
    end
  end

  def delete
    if @current_user&.authenticate(params[:password])
      begin @current_user.delete
        render status: 200, json: {status: 200, msg: "Delete Account Success."}
      rescue
        render status: 400, json: {status: 400, msg: "Delete Account Failed"}
      end
    else
      render status: 401, json: {status: 401, msg: "Invalid password"}
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
