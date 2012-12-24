namespace :collect do
  desc "Initially collect Non GOV.UK data"
  task :init => [:init_businesslink_visits, :init_directgov_visits, :init_businesslink_visitors, :init_directgov_visitors]

  {
      :init_businesslink_visits => {:site => 'businesslink', :metric =>  'visits'},
      :init_directgov_visits => {:site => 'directgov', :metric =>  'visits'},
      :init_businesslink_visitors => {:site => 'businesslink', :metric =>  'visitors'},
      :init_directgov_visitors => {:site => 'directgov', :metric =>  'visitors'}
  }.each do |key, params|
    task key do
      rack_env = ENV.fetch('RACK_ENV', 'development')
      root_path = File.expand_path(File.dirname(__FILE__) + "/../../")
      sh %{cd #{root_path} && RACK_ENV=#{rack_env} bundle exec collector --site=#{params[:site]} --metric=#{params[:metric]} broadcast}
    end
  end
end
