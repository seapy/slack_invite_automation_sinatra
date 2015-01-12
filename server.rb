require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'rack/csrf'
require 'multi_json'

use Rack::Deflater
use Rack::Csrf

enable :sessions
set :session_secret, ENV['SESSION_SECRET_KEY']

set :slack_invite_api_url,    'https://slack.com/api/users.admin.invite'
set :background_color,        ENV.fetch('BACKGROUND_COLOR', '#34495E')
set :text_color,              ENV.fetch('TEXT_COLOR', '#FDFCFB')
set :email_background_color,  ENV.fetch('EMAIL_BACKGROUND_COLOR', '#FDFCFB')
set :email_text_color,        ENV.fetch('EMAIL_TEXT_COLOR', '#737373')
set :button_color,            ENV.fetch('BUTTON_COLOR', '#F39C12')
set :button_hover_color,      ENV.fetch('BUTTON_HOVER_COLOR', '#D78D19')
set :button_text_color,       ENV.fetch('BUTTON_TEXT_COLOR', '#FDFCFB')


get '/' do
  @team_name = ENV['SLACK_TEAM_NAME']
  @description = ENV['SLACK_TEAM_DESC']
  erb :index
end


post '/' do 
  @team_name = ENV['SLACK_TEAM_NAME']
  @email = params[:email]

  response = Excon.post(settings.slack_invite_api_url,
              body: URI.encode_www_form(
                      token: ENV['SLACK_TOKEN'],
                      email: @email,
                      set_active: true
                    ),
              headers: { "Content-Type" => "application/x-www-form-urlencoded" })

  @result = false
  if response.status == 200
    json = MultiJson.load(response.body)
    if json["ok"]
      @result = true
    end
  end
  erb :request
end