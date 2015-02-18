require 'rubygems'
require 'bundler'

$LOAD_PATH.unshift (File.dirname(__FILE__) + "/..")
require 'slack_invite_automation/config/sidekiq'
require 'slack_invite_automation/worker/invite_worker'

Dotenv.load
Bundler.require

module SlackInviteAutomation
  class Server < Sinatra::Application
    set :bind, '0.0.0.0'
    set :session_secret,          ENV['SESSION_SECRET_KEY']
    set :slack_invite_api_url,    'https://slack.com/api/users.admin.invite'
    set :background_color,        ENV.fetch('BACKGROUND_COLOR', '#34495E')
    set :text_color,              ENV.fetch('TEXT_COLOR', '#FDFCFB')
    set :email_background_color,  ENV.fetch('EMAIL_BACKGROUND_COLOR', '#FDFCFB')
    set :email_text_color,        ENV.fetch('EMAIL_TEXT_COLOR', '#737373')
    set :button_color,            ENV.fetch('BUTTON_COLOR', '#F39C12')
    set :button_hover_color,      ENV.fetch('BUTTON_HOVER_COLOR', '#D78D19')
    set :button_text_color,       ENV.fetch('BUTTON_TEXT_COLOR', '#FDFCFB')
    set :team_name,               ENV.fetch('SLACK_TEAM_NAME', 'Team Name')
    set :team_desc,               ENV.fetch('SLACK_TEAM_DESC', 'Your Team description is here.')

    get '/' do
      erb :index
    end

    post '/invite' do
      @email = params[:email]
      @result = true

      InviteWorker.perform_async @email
      
      erb :invite
    end
  end
end
