# Pay-PagerDuty

This utility can be used to:

- Pull user and schedule data from PagerDuty
- Push 'schedule overrides' to PagerDuty

It was developed by GOV.UK Pay but is not currently being used.
It was designed to work specifically with Pay's support rota which works as follows:

* in hours support is 09:30 - 17:30 on weekdays
* on call is 17:30-09:30 on weekdays and 17:30 Friday - 09:30 Monday on weekends
* a rotation starts on a Wednesday at 09:30

The utility has rudimentary support for bank holidays, but it doesn't quite work.

## Prerequisites

* ruby 3.2
* [bundler](http://bundler.io/)
* API key for PagerDuty API v2
  * You can create one by signing into PagerDuty and navigating to Profile -> "User Settings" -> "Create API User Token"

## Setup

Use bundler to install required packages:

```
bundle install
```

Set your API key ENV variable, e.g.:

```
export PAGER_DUTY_API_KEY=$(more ~/pagerduty_token.txt)
```

Populate the `data/schedules.csv` and `data/users.csv` files by running:

```
bundle exec ./bin/schedule -u -s
```

Create a dummy bank holidays file (otherwise the scripts will fail):

```
echo '{ "events": [] }' > data/bank-holidays.json 
```

In the CSVs, remove any schedules and users that are outside of your department.

Finally, add a `Type` column to `data/schedules.csv`. Each row should have a `Type` value of either `in_hours` or `out_of_hours`.

## Usage

Run with `--help` for usage:

```
$ bundle exec bin/schedule --help

  checks pager duty schedule
  requires PAGER_DUTY_API_KEY env var

    -y, --apply  apply overrides
    -n, --dry-run  go through the motions of applying overrides, but don't actually do it
    -u, --get-users  fetch user list
    -s, --get-schedules  fetch schedules
    --help
```

Create a `data/rota.csv` file and fill it in with the schedules, users, and dates (in `YYYY-MM-DD` format) you'd like to apply to PagerDuty. For example:

```csv
Week Commencing,Primary - in hours,Secondary - in hours
2017-06-28,Jane,Ella
2017-07-05,Simone,Anna
```

Do a dry run:

```
$ bundle exec ./bin/schedule -n
```

This will work through each schedule listed in `schedules.csv` and for each one:

- Fetch the schedule from PagerDuty, covering the date range of the entries in `rota.csv`
- Check that the actual schedule matches `rota.csv`
- If it doesn't, it will attempt to create overrides to correct it (these are not applied in dry-run mode)

When you're happy with the proposed changes, apply them with:

```
$ bundle exec ./bin/schedule -y
```

## Testing

```
bundle exec rspec
```

## Licence

[MIT License](LICENCE)
