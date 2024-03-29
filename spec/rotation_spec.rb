require "rotation"

RSpec.describe Rotation do
  let(:actual_name) { "Ella Smith" }
  let(:actual_id) { "ES123" }
  let(:actual_schedule) do
    {
      "start" => "2017-07-14T09:30:00+01:00",
      "end" => "2017-07-14T17:30:00+01:00",
      "user" => {
        "id" => actual_id,
        "type" => "user_reference",
        "summary" => actual_name,
        "self" => "https://api.pagerduty.com/users/#{actual_id}",
        "html_url" => "https://govukpay.pagerduty.com/users/#{actual_id}",
      },
      "id" => "abc123",
    }
  end
  let(:users) do
    {
      "Someone else" => "SE123",
      actual_name => actual_id,
    }
  end

  it "a rotation with the same name is valid, dates ignored" do
    r = described_class.new("2017-06-28", actual_name, actual_id)

    expect(r.valid?(actual_schedule)).to be(true)
  end

  it "a rotation with different same name is invalid, dates ignored" do
    r = described_class.new("2017-06-28", "Someone else", "SE123")

    expect(r.valid?(actual_schedule)).to be(false)
  end

  it "overlaps if the rotation includes the specified slot" do
    r = described_class.new("2017-07-12", "Someone else", "SE123")

    expect(r.includes?(actual_schedule, :in_hours)).to be(true)
  end

  it "overlaps if the rotation starts on the specified slot" do
    r = described_class.new("2017-07-14", "Someone else", "SE123")

    expect(r.includes?(actual_schedule, :in_hours)).to be(true)
  end

  it "does not overlap if the rotation starts after the specified slot" do
    r = described_class.new("2017-07-15", "Someone else", "SE123")

    expect(r.includes?(actual_schedule, :in_hours)).to be(false)
  end

  it "does not overlap if the rotation starts seven days before the specified slot" do
    r = described_class.new("2017-07-07", "Someone else", "SE123")

    expect(r.includes?(actual_schedule, :in_hours)).to be(false)
  end

  it "overlaps if the rotation starts six days before the specified slot" do
    r = described_class.new("2017-07-08", "Someone else", "SE123")

    expect(r.includes?(actual_schedule, :in_hours)).to be(true)
  end

  it "does not overlap if the rotation includes the specified slot but is of a different schedule type" do
    r = described_class.new("2017-07-12", "Someone else", "SE123")

    expect(r.includes?(actual_schedule, :out_of_hours)).to be(false)
  end

  context "when an out of hours rotation" do
    let(:actual_schedule) do
      {
        "start" => "2017-07-04T17:30:00+01:00",
        "end" => "2017-07-05T09:30:00+01:00",
        "user" => {
          "id" => actual_id,
          "type" => "user_reference",
          "summary" => actual_name,
          "self" => "https://api.pagerduty.com/users/#{actual_id}",
          "html_url" => "https://govukpay.pagerduty.com/users/#{actual_id}",
        },
        "id" => "abc123",
      }
    end

    it "overlaps if the rota week ends on the day when the oncall period starts" do
      r = described_class.new("2017-06-28", "Someone else", "SE123")
      expect(r.includes?(actual_schedule, :out_of_hours)).to be(true)
    end

    it "doesn't overlaps if the rota week starts on the day when the oncall period ends" do
      r = described_class.new("2017-07-05", "Someone else", "SE123")
      expect(r.includes?(actual_schedule, :out_of_hours)).to be(false)
    end
  end
end
