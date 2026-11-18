# frozen_string_literal: true

require 'test_helper'

class AnnouncementsHelperTest < ActionView::TestCase
  test '本文中のURLをリンクに変換する' do
    result = announcement_body_with_links('ブログはこちら https://example.com')

    assert_includes result, '<a'
    assert_includes result, 'href="https://example.com"'
    assert_includes result, 'target="_blank"'
    assert_includes result, 'rel="noopener noreferrer"'
  end

  test '本文に含まれる危険なHTMLタグを除去する' do
    result = announcement_body_with_links('<script>alert("xss")</script>')

    assert_no_match(/<script>/, result)
    assert_includes result, 'alert("xss")'
  end
end
