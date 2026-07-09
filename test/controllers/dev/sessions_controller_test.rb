# frozen_string_literal: true

require 'test_helper'

module Dev
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test 'creates session for selected user' do
      user = User.create!(
        line_user_id: 'dev_test_user',
        name: '開発用テストユーザー'
      )

      post dev_session_path, params: { line_user_id: user.line_user_id }

      assert_equal user.id, session[:user_id]
      assert_redirected_to root_path
    end
  end
end
