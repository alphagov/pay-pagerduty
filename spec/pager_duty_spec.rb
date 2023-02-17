require 'pager_duty'
require 'json'

RSpec.describe PagerDuty do
  it "paginates through the list of users" do
    user = {
      "id" => "P69OQXR",
      "name" => "Some User",
      "email" => "some-user@digital.cabinet-office.gov.uk",
      "teams" => [{
        "id" => "PG4Z8YR",
        "type" => "team_reference",
        "summary" => "GOV.UK",
      }],
    }

    request_1 = stub_request(:get, "https://api.pagerduty.com/users?limit=100&offset=0").
      to_return(
        headers: {"Content-Type" => "application/json"},
        body: {
          users: [
            user,
            # imagine there are 99 more
          ],
          limit: 100,
          offset: 0,
          more: true,
        }.to_json)
    request_2 = stub_request(:get, "https://api.pagerduty.com/users?limit=100&offset=100").
      to_return(
        headers: {"Content-Type" => "application/json"},
        body: {
          users: [
            user, # pretend this is a different user to the one from the first request. It doesn't really matter.
            # as before, imagine there are up to 99 more
          ],
          limit: 100,
          offset: 100,
          more: false,
        }.to_json)

    pd = PagerDuty.new(api_token: "dummy")
    expect(pd.users).to eq([user, user])
    expect(request_1).to have_been_requested
    expect(request_2).to have_been_requested
  end

  # it "override payload" do
  #   pd = PagerDuty.new(api_token: "dummy")
  #   from = DateTime.parse('2017-08-30T09:30:00+01:00')
  #   to = DateTime.parse('2017-08-30T17:30:00+01:00')
  #   payload = pd.override_payload(from, to, "my id")
  #   parsed = JSON.parse(payload)
  #   expected = {
  #     override: {
  #       start: '2017-08-30T09:30:00+01:00',
  #       end: '2017-08-30T17:30:00+01:00',
  #       user: {
  #         id: 'my id',
  #         type: 'user_reference'
  #       }
  #     }
  #   }.to_json

  #   expect(JSON.parse(payload)).to eq(JSON.parse(expected))
  # end
end
