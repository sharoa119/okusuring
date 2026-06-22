# frozen_string_literal: true

require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "aboutページが表示される" do
    get about_url
    assert_response :success
  end

  test "利用規約ページが表示される" do
    get terms_url
    assert_response :success
  end

  test "プライバシーポリシーページが表示される" do
    get privacy_url
    assert_response :success
  end
end
