# frozen_string_literal: true

class Cli
  attr_reader :argv

  def initialize(argv = ARGV)
    @argv = argv
  end

  def apply_overrides?
    argv.include?('-y') || argv.include?('--apply')
  end

  def dry_run?
    argv.include?('-n') || argv.include?('--dry-run')
  end

  def get_users?
    argv.include?('-u') || argv.include?('--get-users')
  end

  def get_schedules?
    argv.include?('-s') || argv.include?('--get-schedules')
  end

  def help?
    argv.include?('--help')
  end

  def banner!
    warn %(
  checks pager duty schedule
  requires PAGER_DUTY_API_KEY env var

    -y, --apply  apply overrides
    -n, --dry-run  go through the motions of applying overrides, but don't actually do it
    -u, --get-users  fetch user list
    -s, --get-schedules  fetch schedules
    --help
)
  end
end
