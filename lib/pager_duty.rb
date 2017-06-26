class PagerDuty
  attr_reader :api_token

  def initialize(api_token: )
    @api_token = api_token
  end

  def schedule(schedule_id, from_date, to_date)
    HTTParty.get(
      "https://api.pagerduty.com/schedules/#{schedule_id}?since=#{from_date}&until=#{to_date}",
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

  def override_payload(from, to, user_id)
    {
      override: {
        start: from,
        end: to,
        user: {
          id: user_id,
          type: 'user_reference'
        }
      }
    }.to_json
  end

  def create_override(schedule_id, from, to, user_id)
    HTTParty.post(
      "https://api.pagerduty.com/schedules/#{schedule_id}/overrides",
      body: override_payload(from, to, user_id).to_json,
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/vnd.pagerduty+json;version=2',
        'Authorization' => "Token token=#{api_token}"
      }
    )
  end
end
