require "date"
require "time"

Rotation = Struct.new(:start, :name, :user_id) do
  def initialize(start, name, user_id)
    super(Date.parse(start), name, user_id)
  end

  def start_date
    start
  end

  def end_date
    start + 7
  end

  def valid?(actual_schedule)
    actual_user_id = actual_schedule["user"]["id"]
    user_id == actual_user_id
  end

  def includes?(actual_schedule, schedule_type)
    actual_start = DateTime.parse(actual_schedule["start"])

    if (schedule_type == :in_hours && actual_start.strftime("%H:%M") != "09:30") ||
        (schedule_type == :out_of_hours && actual_start.strftime("%H:%M") == "09:30")
      return false
    end

    includes_date?(actual_start)
  end

  def includes_date?(actual_date)
    start_date < actual_date && end_date > actual_date
  end
end
