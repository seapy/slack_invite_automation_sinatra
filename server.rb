require 'rubygems'
require 'bundler'
require 'slack_invitation'
require 'dotenv'

Dotenv.load
Bundler.require

use Rack::Deflater
use Rack::Csrf

enable :sessions
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

helpers do
  def invite_request_to_slack
    response = Excon.post(settings.slack_invite_api_url,
                body: URI.encode_www_form(
                        token: ENV['SLACK_TOKEN'],
                        email: @email,
                        set_active: true
                      ),
                headers: { "Content-Type" => "application/x-www-form-urlencoded" })
    @result = response.status == 200 && MultiJson.load(response.body)["ok"]
    logger.info { response.body } unless @result
    @result
  end

  def invite
    team = ENV['SLACK_TEAM_NAME']
    admin_email = ENV['SLACK_ADMIN_EMAIL']
    admin_password = ENV['SLACK_ADMIN_PASSWORD']
    
    invitator = SlackInvitation::Invitator.instance
    invitator.config(team, admin_email, admin_password)
    result = invitator.invite(@email) 
    invitator.quit

    result
  end
end

get '/' do
  erb :index
end

post '/invite' do
  @email = params[:email]
  @result = invite
  erb :invite
end
