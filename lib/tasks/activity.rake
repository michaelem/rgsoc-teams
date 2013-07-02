require 'feed'
require 'repository_activity'

namespace :activity do
  desc 'Update activity'
  task update: :environment do
    Feed.update_all
  end
  
  desc 'github events temporary testing task'
  task :github, [:login, :oauth_token] => :environment do |t, args|
    RepositoryActivity.update_all(args)
  end
end
