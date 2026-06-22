# frozen_string_literal: true

require 'line/bot/v2/messaging_api/api/messaging_api_client'

class LineBotClient
  def self.client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV.fetch('LINE_CHANNEL_TOKEN', nil)
    )
  end

  def self.push_text(user_id, text)
    client.push_message(
      push_message_request: Line::Bot::V2::MessagingApi::PushMessageRequest.new(
        to: user_id,
        messages: [
          Line::Bot::V2::MessagingApi::TextMessage.new(
            text: text
          )
        ]
      )
    )
  end
end
