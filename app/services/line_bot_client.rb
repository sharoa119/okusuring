# frozen_string_literal: true

require "line/bot/v2/messaging_api/api/messaging_api_client"

class LineBotClient
  def self.client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV["LINE_CHANNEL_TOKEN"]
    )
  end
end
