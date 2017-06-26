class Cli
  attr_reader :argv

  def initialize(argv = ARGV)
    @argv = argv
  end

  def apply_overrides?
    argv.include?("-y") || argv.include?("--apply")
  end

  def dry_run?
    argv.include?("-n") || argv.include?("--dry-run")
  end

  def get_users?
    argv.include?("-u") || argv.include?("--get-users")
  end

  def get_schedules?
    argv.include?("-s") || argv.include?("--get-schedules")
  end

  def help?
    argv.include?("--help")
  end

  def banner!
    $stderr.puts %{
  checks pager duty schedule
  requires PAGER_DUTY_API_KEY env var

    -y, --apply  apply overrides
    -u, --get-users  fetch user list
    -s, --get-schedules  fetch schedules
    --help
}
  end
end
