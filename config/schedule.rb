root_path = File.expand_path(File.dirname(__FILE__) + "/../")
set :output, {
    :standard => "#{root_path}/log/cron.out.log",
    :error => "#{root_path}/log/cron.err.log"
}
job_type :collector, "cd :path && RACK_ENV=:environment bundle exec bin/collector --site=:site --metric=:metric :task :output"



every [:monday, :tuesday], :at => '4pm' do
  collector "broadcast", :site => "businesslink", :metric => "visits"
  collector "broadcast", :site => "directgov", :metric => "visits"
  collector "broadcast", :site => "businesslink", :metric => "visitors"
  collector "broadcast", :site => "directgov", :metric => "visitors"
end
