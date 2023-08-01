require "csv"

class Rota
  attr_reader :rota, :users, :schedules

  def initialize(rota_file:, users_file:, schedules_file:)
    @rota = CSV.read(rota_file, headers: true)
    @users = CSV.read(users_file, headers: true)
    @schedules = CSV.read(schedules_file, headers: true)
  end

  def rotations(which_one)
    rota.map do |row|
      start_date = row["Week Commencing"]
      staff_name = row.fetch(which_one)
      staff_id = find_user_id(staff_name)
      Rotation.new(
        start_date,
        staff_name,
        staff_id,
      )
    end
  end

  def schedule_id(name)
    match = schedules.find do |row|
      row["Name"] == name
    end

    if match
      match["ID"]
    else
      raise "Can't find schedule #{name}"
    end
  end

  def from_date(which_one)
    rotations(which_one).map(&:start_date).min
  end

  def from(which_one)
    date = from_date(which_one)
    Time.zone.parse("#{date.iso8601}T09:30")
  end

  def to(which_one)
    date = rotations(which_one).map(&:end_date).max + 1
    Time.zone.parse("#{date.iso8601}T09:30")
  end

  def find_user_id(name)
    match = users.find do |row|
      row["Name"] == name
    end

    if match
      match["ID"]
    else
      raise "Can't find user '#{name}'"
    end
  end
end
