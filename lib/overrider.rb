require "date"
require "time"
require "active_support"
require "active_support/core_ext/time/zones"
require "override"

class Overrider
  attr_reader :rotation, :schedule_type

  def initialize(rotation, schedule_type)
    @rotation = rotation
    @schedule_type = schedule_type
  end

  def overrides
    raise "Illegal schedule_type '#{schedule_type}" unless valid_schedule_type?

    rota_starts.zip(rota_ends).map do |from, to|
      Override.new(from, to, rotation.user_id, rotation.name)
    end
  end

  def rota_starts
    if schedule_type == :in_hours
      (rotation.start_date...rotation.start_date + 7)
        .reject(&:saturday?)
        .reject(&:sunday?)
        .map do |date|
          Time.use_zone("Europe/London") do
            Time.zone.parse("#{date}T09:30:00")
          end
        end
    elsif schedule_type == :out_of_hours
      (rotation.start_date...rotation.start_date + 7)
        .reject(&:saturday?)
        .reject(&:sunday?)
        .map do |date|
          Time.use_zone("Europe/London") do
            Time.zone.parse("#{date}T17:30:00")
          end
        end
    end
  end

  def rota_ends
    if schedule_type == :in_hours
      (rotation.start_date...rotation.start_date + 7)
        .reject(&:saturday?)
        .reject(&:sunday?)
        .map do |date|
          Time.use_zone("Europe/London") do
            Time.zone.parse("#{date}T17:30:00")
          end
        end
    elsif schedule_type == :out_of_hours
      (rotation.start_date + 1...rotation.start_date + 8)
        .reject(&:saturday?)
        .reject(&:sunday?)
        .map do |date|
          Time.use_zone("Europe/London") do
            Time.zone.parse("#{date}T09:30:00")
          end
        end
    end
  end

  def valid_schedule_type?
    %i[in_hours out_of_hours].include?(schedule_type)
  end
end
