class PagerDuty
  attr_reader :api_token

  def initialize(api_token: )
    @api_token = api_token
  end

  def schedules
    HTTParty.get(
      "https://api.pagerduty.com/schedules",
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/vnd.pagerduty+json;version=2',
        'Authorization' => "Token token=#{api_token}"
      }
    )
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
    HTTParty.get(
      "https://api.pagerduty.com/users",
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/vnd.pagerduty+json;version=2',
        'Authorization' => "Token token=#{api_token}"
      }
    )
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
