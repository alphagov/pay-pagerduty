## Pager duty schedule

Configure the expected schedule using CSV files in the `data/` subdirectory.

There are three files you need:

1. `data/schedules.csv` - defines the `Name`, `ID` and `Type` of each schedule (Type is either `in_hours` or `out_of_hours`)
1. `data/users.csv` - defines the `Name` and `ID` of users
1. `data/rota.csv` - defines the rota, using the following columns:
    1. 'Week Commencing' - in format `YYYY-MM-DD`
    1. '<Schedule name 1>' - heading corresponds to the name of the schedule, value is the name of the user
    1. '<Schedule name 2>' - etc...

## Prerequisites

* ruby 2.x
* [bundler](http://bundler.io/)

## This is opinionated

It's designed to work specifically with our support rota which works as follows:

* in hours support is 09:30 - 17:30 on weekdays
* on call is 17:30-09:30 on weekdays and weekends
* a rotation starts on a Wednesday at 09:30

We *do* take into account bank holidays.

## Usage

Use bundler to install required packages:

```
$ bundle install
```

Then setup user and schedule data:

```
$ bundle exec ./bin/schedule -u -s
```

This fetches the list of users and schedules from pager duty and stores them in `data/`. You'll need to add the `Type` column to `data/schedules.csv`

Now create `data/rota.csv` and fill it in correctly.

```
Week Commencing,Primary - in hours,Secondary - in hours
2017-06-28,Jane,Ella
2017-07-05,Simone,Anna
```

The data format needs to be `YYYY-MM-DD`.

Now you can do a dry run:

```
$ bundle exec ./bin/schedule -n
```

This works through each schedule listed in `schedules.csv` and for each one:

- fetches the schedule from pager duty covering the date range of the entries in `rota.csv`
- checks that the actual schedule matches `rota.csv`
- if it doesn't, it will attempt to create overrides to correct it (these are not applied in dry-run mode)

When you're happy with the proposed changes go ahead and apply them:

```
$ bundle exec ./bin/schedule -y
```



