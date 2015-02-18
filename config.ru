require 'rack/cors'
require 'rack/csrf'

require './lib/slack_invite_automation'

use Rack::Deflater
use Rack::Session::Cookie
use Rack::Csrf

run SlackInviteAutomation::Server
