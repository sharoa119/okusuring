require "test_helper"

class MedicationRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get medication_records_create_url
    assert_response :success
  end
end
