def cron_command(site, metric)
  root_path = File.expand_path(File.dirname(__FILE__) + "/../")

  "cd #{root_path} && RACK_ENV=production bundle exec bin/collector -s=#{site} -m=#{metric} broadcast" +
  " >> #{root_path}/log/cron.out.log 2>> #{root_path}/log/cron.err.log"
end


every [:monday, :tuesday], :at => '4pm' do
  command cron_command(site = "businesslink", metric = "visits")
  command cron_command(site = "directgov", metric = "visits")
  command cron_command(site = "businesslink", metric = "visitors")
  command cron_command(site = "directgov", metric = "visitors")
end
