require "test_helper"

class MedicationSchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get medication_schedules_index_url
    assert_response :success
  end
end
