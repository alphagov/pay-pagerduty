## Pager duty schedule

Configure the expected schedule using CSV files in the `data/` subdirectory.

There are three files you need:

1. `data/schedules.csv` - defines the `Name` and `ID` of each schedule
1. `data/users.csv` - defines the `Name` and `ID` of users
1. `data/rota.csv` - defines the rota, using the following columns:
  1. 'Week Commencing' - in format `YYYY-MM-DD`
  2. '<Schedule name 1>' - heading corresponds to the name of the schedule, value is the name of the user
  2. '<Schedule name 2>' - etc...

