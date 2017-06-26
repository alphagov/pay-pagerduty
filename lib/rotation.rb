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
    from = DateTime.parse(actual_schedule['start'])
    to = DateTime.parse(actual_schedule['end'])

    start_date < from && end_date > to
  end
end