require 'rotation'

RSpec.describe Rotation do

  let(:actual_name) { "Ella Smith" }
  let(:actual_id) { "ES123" }
  let(:actual_schedule) {
    {
      "start"=>"2017-07-14T09:30:00+01:00",
      "end"=>"2017-07-14T17:30:00+01:00",
      "user"=>{
        "id"=>actual_id, "type"=>"user_reference", "summary"=>actual_name, 
        "self"=>"https://api.pagerduty.com/users/#{actual_id}", 
        "html_url"=>"https://govukpay.pagerduty.com/users/#{actual_id}"
      },
      "id"=>"abc123"
    }
  }
  let(:users) {
    {
      "Someone else" => "SE123",
      actual_name => actual_id,
    }
  }

  it "a rotation with the same name is valid, dates ignored" do
    r = Rotation.new("2017-06-28", actual_name, actual_id)

    expect(r.valid?(actual_schedule)).to be(true)
  end

  it "a rotation with different same name is invalid, dates ignored" do
    r = Rotation.new("2017-06-28", "Someone else", "SE123")

    expect(r.valid?(actual_schedule)).to be(false)
  end

  it "a rotation which includes the specified slot is considered to overlap" do
    r = Rotation.new("2017-07-12", "Someone else", "SE123")

    expect(r.includes?(actual_schedule)).to be(true)
  end

  it "a rotation which starts on the specified slot is considered to overlap" do
    r = Rotation.new("2017-07-14", "Someone else", "SE123")

    expect(r.includes?(actual_schedule)).to be(true)
  end

  it "a rotation which starts after the specified slot is not considered to overlap" do
    r = Rotation.new("2017-07-15", "Someone else", "SE123")

    expect(r.includes?(actual_schedule)).to be(false)
  end

  it "a rotation which starts seven days before the specified slot is not considered to overlap" do
    r = Rotation.new("2017-07-07", "Someone else", "SE123")

    expect(r.includes?(actual_schedule)).to be(false)
  end

  it "a rotation which starts six days before the specified slot is considered to overlap" do
    r = Rotation.new("2017-07-08", "Someone else", "SE123")

    expect(r.includes?(actual_schedule)).to be(true)
  end
end