set :application, "Drukarnia"

set :deploy_to, "/home/drukarnia/www/drukarnia/"
set :deploy_via, :remote_cache
set :user, "drukarnia"
set :use_sudo, false

set :scm, :git
set :scm_username, "streflik"
set :repository, "git@github.com:streflik/drukarnia.git"
set :branch, "master"
set :git_enable_submodules, 1
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "drukarnia.megiteam.pl"                          # Your HTTP server, Apache/etc
role :app, "drukarnia.megiteam.pl"                          # This may be the same as your `Web` server
role :db,  "drukarnia.megiteam.pl", :primary => true # This is where Rails migrations will run
role :db,  "drukarnia.megiteam.pl"

namespace :deploy do
  task :start, :roles => :app do
    run "restart-app drukarnia"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "restart-app drukarnia"
  end

  desc "Symlink shared resources on each release"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application.rb #{release_path}/config/application.rb"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

namespace :bundler do
  desc "Symlink bundled gems on each release"
  task :symlink_bundled_gems, :roles => :app do
    run "mkdir -p #{shared_path}/bundled_gems"
    run "ln -nfs #{shared_path}/bundled_gems #{release_path}/vendor/bundle"
  end

  desc "Install for production"
  task :install, :roles => :app do
    run "cd #{release_path} && bundle install && rake db:migrate"
  end

end

after 'deploy:update_code', 'bundler:symlink_bundled_gems'
after 'deploy:update_code', 'bundler:install'

        #require './config/boot'

