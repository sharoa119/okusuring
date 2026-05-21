set :environment, "development"

every 1.minute do
  runner "MedicationNotifier.notify_now"
end
