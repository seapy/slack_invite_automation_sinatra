require 'rack/cors'
require 'rack/csrf'
require 'dotenv'

Dotenv.load

require './lib/slack_invite_automation'

use Rack::Deflater
use Rack::Session::Cookie, secret: ENV['SESSION_SECRET_KEY']
use Rack::Csrf

run SlackInviteAutomation::Server
