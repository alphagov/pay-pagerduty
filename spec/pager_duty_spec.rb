require "pager_duty"
require "json"

RSpec.describe PagerDuty do
  let(:user) do
    {
      "id" => "P69OQXR",
      "name" => "Some User",
      "email" => "some-user@digital.cabinet-office.gov.uk",
      "teams" => [team],
    }
  end
  let(:team) do
    {
      "id" => "PG4Z8YR",
      "type" => "team_reference",
      "summary" => "GOV.UK",
    }
  end

  it "retrieves the full list of schedules" do
    schedule = {
      "id" => "PFTO260",
      "type" => "schedule",
      "summary" => "Some schedule",
      "name" => "Some schedule",
      "description" => "Schedule description",
      "web_cal_url" => "webcal://*.pagerduty.com/private/abcdef/feed/PFTO260",
      "http_cal_url" => "https://*.pagerduty.com/private/abcdef/feed/PFTO260",
      "users" => [user],
      "escalation_policies" => [],
      "teams" => [team],
    }

    request = stub_request(:get, "https://api.pagerduty.com/schedules?limit=100")
      .to_return(
        headers: { "Content-Type" => "application/json" },
        body: {
          schedules: [
            schedule,
            # imagine there are 99 more
          ],
          limit: 100,
          offset: 0,
          more: true,
        }.to_json,
      )

    pd = described_class.new(api_token: "dummy")
    expect(pd.schedules).to eq([schedule])
    expect(request).to have_been_requested
  end

  it "paginates through the list of users" do
    request_1 = stub_request(:get, "https://api.pagerduty.com/users?limit=100&offset=0")
      .to_return(
        headers: { "Content-Type" => "application/json" },
        body: {
          users: [
            user,
            # imagine there are 99 more
          ],
          limit: 100,
          offset: 0,
          more: true,
        }.to_json,
      )
    request_2 = stub_request(:get, "https://api.pagerduty.com/users?limit=100&offset=100")
      .to_return(
        headers: { "Content-Type" => "application/json" },
        body: {
          users: [
            user, # pretend this is a different user to the one from the first request. It doesn't really matter.
            # as before, imagine there are up to 99 more
          ],
          limit: 100,
          offset: 100,
          more: false,
        }.to_json,
      )

    pd = described_class.new(api_token: "dummy")
    expect(pd.users).to eq([user, user])
    expect(request_1).to have_been_requested
    expect(request_2).to have_been_requested
  end
end
