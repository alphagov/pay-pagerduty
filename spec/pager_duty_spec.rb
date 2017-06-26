require 'pager_duty'
require 'json'

RSpec.describe PagerDuty do
  it "override payload" do
    pd = PagerDuty.new(api_token: "dummy")
    from = DateTime.parse('2017-08-30T09:30:00+01:00')
    to = DateTime.parse('2017-08-30T17:30:00+01:00')
    payload = pd.override_payload(from, to, "my id")
    parsed = JSON.parse(payload)
    expected = {
      override: {
        start: '2017-08-30T09:30:00+01:00',
        end: '2017-08-30T17:30:00+01:00',
        user: {
          id: 'my id',
          type: 'user_reference'
        }
      }
    }.to_json

    expect(JSON.parse(payload)).to eq(JSON.parse(expected))
  end
end