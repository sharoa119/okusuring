set :environment, "development"
env :PATH, ENV["PATH"]
set :output, "log/cron.log"

job_type :runner, "cd :path && /Users/saully/.rbenv/shims/bundle exec rails runner -e :environment ':task' :output"

every 1.minute do
  runner "MedicationNotifier.notify_now"
end
