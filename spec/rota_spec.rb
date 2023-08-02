require "rota"

RSpec.describe Rota do
  let(:fixture_path) { "#{File.dirname(__FILE__)}/fixtures/" }

  it "reads from csv" do
    r = described_class.new(
      rota_file: "#{fixture_path}/rota.csv",
      users_file: "#{fixture_path}/users.csv",
      schedules_file: "#{fixture_path}/schedules.csv",
    )

    expect(r.rotations("In Hours 1").size).to eq(1)
    expected_rotation = Rotation.new("2017-06-28", "Ella Smith", "ES123")
    expect(r.rotations("In Hours 1").first).to eq(expected_rotation)
    expect(r.schedule_id("In Hours")).to eq("ABC123")
  end
end
