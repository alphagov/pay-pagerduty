require "date"
require "time"

require "rotation"
require "overrider"
require "override"

RSpec.describe Overrider do
  subject(:overrider) { described_class.new(rotation, schedule_type) }

  let(:start) { "2017-06-28" }
  let(:name) { "Ella Smith" }
  let(:user_id) { "ES123" }

  let(:rotation) { Rotation.new(start, name, user_id) }
  let(:schedule_type) { :in_hours }

  it "generates overrides from a rotation" do
    expect(overrider.overrides.size).to eq(5)
    expect(overrider.overrides).to eq([
      Override.new(
        Time.iso8601("2017-06-28T09:30:00+01:00"),
        Time.iso8601("2017-06-28T17:30:00+01:00"),
        user_id,
        name,
      ),
      Override.new(
        Time.iso8601("2017-06-29T09:30:00+01:00"),
        Time.iso8601("2017-06-29T17:30:00+01:00"),
        user_id,
        name,
      ),
      Override.new(
        Time.iso8601("2017-06-30T09:30:00+01:00"),
        Time.iso8601("2017-06-30T17:30:00+01:00"),
        user_id,
        name,
      ),
      Override.new(
        Time.iso8601("2017-07-03T09:30:00+01:00"),
        Time.iso8601("2017-07-03T17:30:00+01:00"),
        user_id,
        name,
      ),
      Override.new(
        Time.iso8601("2017-07-04T09:30:00+01:00"),
        Time.iso8601("2017-07-04T17:30:00+01:00"),
        user_id,
        name,
      ),
    ])
  end

  context "when a rotation overlaps the beginning of the UTC/BST transition" do
    let(:start) { "2017-03-22" }

    it "generates overrides using the appropriate timezone" do
      expect(overrider.overrides.size).to eq(5)
      expect(overrider.overrides).to eq([
        Override.new(
          Time.iso8601("2017-03-22T09:30:00+00:00"),
          Time.iso8601("2017-03-22T17:30:00+00:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-03-23T09:30:00+00:00"),
          Time.iso8601("2017-03-23T17:30:00+00:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-03-24T09:30:00+00:00"),
          Time.iso8601("2017-03-24T17:30:00+00:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-03-27T09:30:00+01:00"),
          Time.iso8601("2017-03-27T17:30:00+01:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-03-28T09:30:00+01:00"),
          Time.iso8601("2017-03-28T17:30:00+01:00"),
          user_id,
          name,
        ),
      ])
    end
  end

  context "when a rotation overlaps the BST=>UTC transition" do
    let(:start) { "2017-10-25" }

    it "generates overrides using the appropriate timezone" do
      expect(overrider.overrides.size).to eq(5)
      expect(overrider.overrides).to eq([
        Override.new(
          Time.iso8601("2017-10-25T09:30:00+01:00"),
          Time.iso8601("2017-10-25T17:30:00+01:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-10-26T09:30:00+01:00"),
          Time.iso8601("2017-10-26T17:30:00+01:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-10-27T09:30:00+01:00"),
          Time.iso8601("2017-10-27T17:30:00+01:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-10-30T09:30:00+00:00"),
          Time.iso8601("2017-10-30T17:30:00+00:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-10-31T09:30:00+00:00"),
          Time.iso8601("2017-10-31T17:30:00+00:00"),
          user_id,
          name,
        ),
      ])
    end
  end

  context "when out of hours" do
    let(:schedule_type) { :out_of_hours }

    it "generates overrides from a rotation" do
      expect(overrider.overrides.size).to eq(5)
      expect(overrider.overrides).to eq([
        Override.new(
          Time.iso8601("2017-06-28T17:30:00+01:00"),
          Time.iso8601("2017-06-29T09:30:00+01:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-06-29T17:30:00+01:00"),
          Time.iso8601("2017-06-30T09:30:00+01:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-06-30T17:30:00+01:00"),
          Time.iso8601("2017-07-03T09:30:00+01:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-07-03T17:30:00+01:00"),
          Time.iso8601("2017-07-04T09:30:00+01:00"),
          user_id,
          name,
        ),
        Override.new(
          Time.iso8601("2017-07-04T17:30:00+01:00"),
          Time.iso8601("2017-07-05T09:30:00+01:00"),
          user_id,
          name,
        ),
      ])
    end

    context "when a rotation overlaps the beginning of the UTC/BST transition" do
      let(:start) { "2017-03-22" }

      it "generates overrides using the appropriate timezone" do
        expect(overrider.overrides.size).to eq(5)
        expect(overrider.overrides).to eq([
          Override.new(
            Time.iso8601("2017-03-22T17:30:00+00:00"),
            Time.iso8601("2017-03-23T09:30:00+00:00"),
            user_id,
            name,
          ),
          Override.new(
            Time.iso8601("2017-03-23T17:30:00+00:00"),
            Time.iso8601("2017-03-24T09:30:00+00:00"),
            user_id,
            name,
          ),
          Override.new(
            Time.iso8601("2017-03-24T17:30:00+00:00"),
            Time.iso8601("2017-03-27T09:30:00+01:00"),
            user_id,
            name,
          ),
          Override.new(
            Time.iso8601("2017-03-27T17:30:00+01:00"),
            Time.iso8601("2017-03-28T09:30:00+01:00"),
            user_id,
            name,
          ),
          Override.new(
            Time.iso8601("2017-03-28T17:30:00+01:00"),
            Time.iso8601("2017-03-29T09:30:00+01:00"),
            user_id,
            name,
          ),
        ])
      end
    end
  end
end
