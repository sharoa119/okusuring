# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test '未ログイン時はログイン前トップが表示される' do
    get root_path

    assert_response :success
    assert_match "おくすリングでできること", response.body
    assert_match 'LINEでログイン', response.body
  end

  test 'ログイン済みの場合は今日のお薬の予定が表示される' do
    user = users(:owner)

    log_in_as(user)

    get root_path

    assert_response :success
    assert_match '今日のお薬の予定', response.body
    assert_match '自分の予定', response.body
    assert_match '血圧の薬', response.body
  end

  test '予定がない場合は今日の服薬予定はありませんが表示される' do
    user = users(:no_schedule_user)

    log_in_as(user)

    get root_path

    assert_response :success
    assert_match '今日の服薬予定はありません', response.body
  end
end
