web: bundle exec rackup -o $SERVER_HOST -p $SERVER_PORT
worker: bundle exec sidekiq -C ./config/sidekiq.yml -r ./lib/slack_invite_automation/server.rb
