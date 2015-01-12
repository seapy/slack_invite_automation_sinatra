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

configure do
  set :slack_invite_api_url, 'https://slack.com/api/channels.list' # for API test
  # set :slack_invite_api_url, 'https://slack.com/api/users.admin.invite'
end



get '/' do
  @team_name = ENV['SLACK_TEAM_NAME']
  erb :index
end


post '/' do 
  @team_name = ENV['SLACK_TEAM_NAME']
  @description = ENV['SLACK_TEAM_DESC']
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