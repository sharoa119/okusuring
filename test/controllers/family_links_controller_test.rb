require "test_helper"

class FamilyLinksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get family_links_index_url
    assert_response :success
  end
end
