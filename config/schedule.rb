every :sunday, :at => '1am' do
  command "cd #{File.expand_path(File.dirname(__FILE__) + "/../")} && RACK_ENV=production bundle exec bin/collector -s=businesslink -m=visits broadcast"
  command "cd #{File.expand_path(File.dirname(__FILE__) + "/../")} && RACK_ENV=production bundle exec bin/collector -s=directgov -m=visits broadcast"
  command "cd #{File.expand_path(File.dirname(__FILE__) + "/../")} && RACK_ENV=production bundle exec bin/collector -s=businesslink -m=visitors broadcast"
  command "cd #{File.expand_path(File.dirname(__FILE__) + "/../")} && RACK_ENV=production bundle exec bin/collector -s=directgov -m=visitors broadcast"
end
