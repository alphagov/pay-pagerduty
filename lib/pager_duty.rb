require 'httparty'

class PagerDuty
  # PagerDuty's maximum: https://developer.pagerduty.com/docs/ZG9jOjExMDI5NTU4-pagination#classic-pagination
  API_LIMIT = 100

  attr_reader :api_token

  def initialize(api_token: )
    @api_token = api_token
  end

  def schedules
    HTTParty.get(
      "https://api.pagerduty.com/schedules?limit=#{API_LIMIT}",
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/vnd.pagerduty+json;version=2',
        'Authorization' => "Token token=#{api_token}"
      }
    )["schedules"]
  end

  def schedule(schedule_id, from_date, to_date)
    HTTParty.get(
      "https://api.pagerduty.com/schedules/#{schedule_id}?since=#{from_date.iso8601}&until=#{to_date.iso8601}",
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/vnd.pagerduty+json;version=2',
        'Authorization' => "Token token=#{api_token}"
      }
    )
  end

  def users
    offset = 0
    users = []
    while true do
      batch_results = HTTParty.get(
        "https://api.pagerduty.com/users?limit=#{API_LIMIT}&offset=#{offset}",
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/vnd.pagerduty+json;version=2',
          'Authorization' => "Token token=#{api_token}"
        }
      )
      users << batch_results["users"]
      break unless batch_results["more"]
      offset = offset + API_LIMIT
    end
    users.flatten
  end

  def create_override(schedule_id, override)
    HTTParty.post(
      "https://api.pagerduty.com/schedules/#{schedule_id}/overrides",
      body: override.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/vnd.pagerduty+json;version=2',
        'Authorization' => "Token token=#{api_token}"
      }
    )
  end
end
