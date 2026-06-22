# frozen_string_literal: true

class LineBotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    event = params[:events].first
    user_id = event.dig('source', 'userId')

    Rails.logger.info("LINE user_id: #{user_id}")
    Rails.logger.info(params.to_unsafe_h)

    user = User.find_by(line_user_id: user_id)

    if user
      user.update!(line_bot_connected: true)
    else
      Rails.logger.info("Unlinked LINE user (ignored): #{user_id}")
    end

    render plain: 'OK'
  end
end
