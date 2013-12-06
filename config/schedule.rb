# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "#{path}/log/cron_log.log"

every 3.hours do  
  rake "hh:pull_latest"
end

# Learn more: http://github.com/javan/whenever
