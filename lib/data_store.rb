require 'csv'
require 'logger'

class DataStore
  attr_reader :path, :logger

  def initialize(logger: Logger.new(STDOUT))
    @path = Pathname.new(File.dirname(__FILE__) + "/../data/")
    @logger = logger
  end

  def write_users(users)
    user_file = path + "users.csv"
    logger.info("Writing #{users.size} users to #{user_file}")
    CSV.open(user_file, "wb") do |c|
      c << ["Name", "ID"]
      users.each do |u|
        c << u
      end
    end
    logger.info("done")
  end

  def schedule_file
    path + "schedules.csv"
  end

  def write_schedules(schedules)
    logger.info("Writing #{schedules.size} schedules to #{schedule_file}")
    CSV.open(schedule_file, "wb") do |c|
      c << ["Name", "ID"]
      schedules.each do |u|
        c << u
      end
    end
    logger.info("done")
  end

  def read_schedules
    CSV.read(schedule_file, headers: true)
  end

end
