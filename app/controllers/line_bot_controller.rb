# frozen_string_literal: true

class LineBotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    Rails.logger.info("=== LINE WEBHOOK ===")
    Rails.logger.info(params)

    render plain: "OK"
  end
end
