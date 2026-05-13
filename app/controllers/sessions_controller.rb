# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    user = User.find_or_create_by(line_user_id: auth.uid)
    user.update(name: auth.info.name)

    session[:user_id] = user.id

    redirect_to root_path, notice: "ログインしました"
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "ログアウトしました"
  end
end
