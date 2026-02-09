class MedicationSchedulesController < ApplicationController
  def index
    @today_schedules = [
      {
        name: "自分",
        schedules: [
          { time: "08:00", name: "朝の薬" },
          { time: "20:00", name: "夜の薬" }
        ]
      },
      {
        name: "line_user_id",
        schedules: []
      },
      {
        name: "子ども",
        schedules: [
          { time: "07:30", name: "朝の薬" }
        ]
      }
    ]
  end
end
