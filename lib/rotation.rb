require 'date'
require 'time'

class Rotation < Struct.new(:start, :name, :user_id)
  def initialize(start, name, user_id)
    super(Date.parse(start), name, user_id)
  end

  def start_date
    self.start
  end

  def end_date
    self.start + 7
  end

  def valid?(actual_schedule)
    actual_user_id = actual_schedule['user']['id']
    self.user_id == actual_user_id
  end

  def includes?(actual_schedule)
    actual_start = DateTime.parse(actual_schedule['start'])
    actual_end = DateTime.parse(actual_schedule['end'])

    includes_date?(actual_start)
  end

  def includes_date?(actual_date)
    start_date < actual_date && end_date > actual_date
  end
end
