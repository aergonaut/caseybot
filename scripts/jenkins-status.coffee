# Description:
#   Allow Hubot to query build status from Jenkins.
#
#   Note: if you are using digest authentication to secure your Jenkins system
#   you must also set HUBOT_JENKINS_USERNAME and HUBOT_JENKINS_PASSWORD.
#
# Configuration:
#   HUBOT_JENKINS_URL - The full URL to your Jenkins. If using basic auth,
#                       include the username and password in the url like:
#                       https://user:pass@ci.yourcompany.com
#   HUBOT_JENKINS_USERNAME - Optional. Username for digest authentication.
#   HUBOT_JENKINS_PASSWORD - Optional. Password for digest authentication.
#
# Commands:
#   hubot jenkins status <job> - get the status of a particular job
#
# Author:
#   aergonaut

digest = require 'digest-header'
RSVP = require 'rsvp'

module.exports = (robot) ->
  # process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
  jenkins_url = process.env.HUBOT_JENKINS_URL

  options =
    rejectUnauthorized: false

  robot.respond /jenkins status (.*)/i, (msg) ->
    request_path = "/job/#{msg.match[1]}/lastCompletedBuild/api/json"
    build_url = "#{jenkins_url}#{request_path}"

    request = new RSVP.Promise (resolve, reject) ->
      robot.http(build_url, options)
        .get() (err, res, body) ->
          if err
            reject(err)
          else
            if res.statusCode == 401
              method = "GET"
              www_authenticate = res.headers['www-authenticate']
              username = process.env.HUBOT_JENKINS_USERNAME
              password = process.env.HUBOT_JENKINS_PASSWORD
              user_pass = "#{username}:#{password}"
              auth = digest(method, request_path, www_authenticate, user_pass)

              robot.http(build_url, options)
                .header("Authorization", auth)
                .get() (err, res, body) ->
                  resolve(body)
            else
              resolve(body)

    request.then (bodyData) ->
      data = JSON.parse(bodyData)
      build_result = data.result
      full_display_name = data.fullDisplayName
      build_url = data.url

      if build_result == "SUCCESS"
        msg.send "#{full_display_name} built successfully: #{build_url}"
      else
        msg.send "#{full_display_name} failed: #{build_url}"
    , (error) ->
      msg.send "Something went wrong querying Jenkins: #{error}"
