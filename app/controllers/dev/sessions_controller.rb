# frozen_string_literal: true

module Dev
  class SessionsController < ApplicationController
    def new
      @users = dev_user_ids.filter_map do |line_user_id|
        User.find_by(line_user_id:)
      end
    end

    def create
      user = User.find_by!(line_user_id: params[:line_user_id])
      session[:user_id] = user.id

      redirect_to root_path, notice: "#{user.name}としてログインしました"
    end

    private

    def dev_user_ids
      %w[
        dev_owner
        dev_family
        dev_empty
        dev_bot_unlinked
        dev_invitee
      ]
    end
  end
end
