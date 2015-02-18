# Slack invite automation using sinatra

## Usage

### Use Docker

```
$ docker run -d -p 6379:6379 --name redis dockerfile/redis
$ docker run -d \
  -e SLACK_TEAM_NAME="Slack Team Name" \
  -e SLACK_TEAM_DESC="welcome to slack" \
  -e SESSION_SECRET_KEY="your random string" \
  -e SLACK_ADMIN_EMAIL="ADMIN_EMAIL"
  -e SLACK_ADMIN_PASSWORD="ADMIN_PASSWORD"
  -e REDIS_SERVER="172.17.42.1:6379"
  -e REDIS_DB="2"
  -e SERVER_PORT="80"
  -e SERVER_HOST="0.0.0.0"
  -p 8080:80 \
  nacyot/slack_invite
```

## Config

Environments list

* SLACK_TEAM_NAME
  * Your slack team name
* SLACK_TOKEN
  * Your slack api token. get from https://api.slack.com/web#auth
* SESSION_SECRET_KEY
  * For encrypt session data. first make random text and use it.
* SLACK_TEAM_DESC
  * Description of your slack
* optional environments
  * BACKGROUND_COLOR
  * TEXT_COLOR
  * EMAIL_BACKGROUND_COLOR
  * EMAIL_TEXT_COLOR
  * BUTTON_COLOR
  * BUTTON_HOVER_COLOR
  * BUTTON_TEXT_COLOR

## Demo

http://slack-invite.docker.co.kr

## Reference

* [Slack의 팀 초대를 자동화 할 수 있는 "Slack Invite Automation"](http://blog.outsider.ne.kr/1117)
  * [node.js web application](https://github.com/outsideris/slack-invite-automation)
* [How I hacked Slack into a community platform with Typeform](https://levels.io/slack-typeform-auto-invite-sign-ups/)
* [Socket.io Join the Community](http://socket.io/slack/)
* [Sign Up From](http://codepen.io/erikapdx/pen/BnfjH)
  * Thanks for raccoony(Docker Korea Slack) find this design
