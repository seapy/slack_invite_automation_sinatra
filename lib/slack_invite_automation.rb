$LOAD_PATH.unshift File.dirname(__FILE__)

module SlackInviteAutomation
  autoload :Server, 'slack_invite_automation/server'
  autoload :InviteWorker, 'slack_invite_automation/worker/invite_worker'
end
