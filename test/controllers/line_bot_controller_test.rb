# frozen_string_literal: true

require 'test_helper'

class LineBotControllerTest < ActionDispatch::IntegrationTest
  test 'LINEユーザーと連携済みにする' do
    user = User.create!(
      line_user_id: 'line_webhook_test_user',
      name: 'Webhookテストユーザー',
      line_bot_connected: false
    )

    post '/webhook',
         params: {
           events: [
             {
               source: {
                 userId: user.line_user_id
               }
             }
           ]
         },
         as: :json

    assert_response :success
    assert_equal 'OK', response.body
    assert_predicate user.reload, :line_bot_connected?
  end

  test 'イベントが空でも成功を返す' do
    post webhook_path, params: {
      destination: 'test_destination',
      events: []
    }, as: :json

    assert_response :success
  end
end
