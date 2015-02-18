require 'slack_invitation'
require 'sidekiq'
require 'dotenv'

Dotenv.load

module SlackInviteAutomation
  class InviteWorker
    include Sidekiq::Worker

    def perform(email)
      team = ENV['SLACK_TEAM_NAME']
      admin_email = ENV['SLACK_ADMIN_EMAIL']
      admin_password = ENV['SLACK_ADMIN_PASSWORD']
      
      invitator = SlackInvitation::Invitator.instance
      invitator.config(team, admin_email, admin_password)
      invitator.start
      result = invitator.invite(email)

      puts "#{email} : #{result}"
    end
  end
end
