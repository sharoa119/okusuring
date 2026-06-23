# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module LoginSupport
  def setup_omniauth
    OmniAuth.config.test_mode = true
  end

  def teardown_omniauth
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:line] = nil
  end

  def log_in_as(user)
    OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new(
      provider: 'line',
      uid: user.line_user_id,
      info: { name: user.name }
    )

    get '/auth/line/callback'
  end
end

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    fixtures :all
  end
end

module ActionDispatch
  class IntegrationTest
    include LoginSupport
  end
end
