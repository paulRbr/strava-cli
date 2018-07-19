## Strava-CLI gem - Interact with your Strava activities

![Build status](https://gitlab.com/paulrbr/strava/badges/0.0.5/build.svg)

This gem `strava-cli` provides a simple interface to visualise your Strava activities in dedicated dashboards. (For now table or graph). It is on early stage development and more feature should come soon.

## Installation

    gem install strava-cli

That is it, you are good to go!

## Usage

### Configuration

You should start by configuring the gem on your computer first. Create a file in your home directory `~/.strava/strava.yml`

A common configuration file looks like this:

```yaml
# Get your personal access token at https://www.strava.com/settings/api
# WARNING: this information is strictly personal and should not be
#          shared with others. By default Strava provides a "public"
#          access token, meaning that you will only have read-only
#          access to your public activities. If you want to make changes
#          and have a write access follow the steps at
#          http://yizeng.me/2017/01/11/get-a-strava-api-access-token-with-write-permission/
:strava_access_token: <YOUR_STRAVA_API_ACCESS_TOKEN>

# How long do you want Strava's API call to be cached locally (in secs)
# Defaults to: 1 day (86400 seconds)
:cache_time: 600
```

Once configured you can interact with strava!

```bash
> strava --help
Strava Dashboard Version: 0.0.5

Fetchs data from strava to report what you have done
-- Strava options --------------------------------------------------------------
--strava_access_token      Strava access token
--activity                 Display this activity type only (Run, Ride, Swim)
--graph                    Display a graph instead of a table
--scope                    Display limited scoped activities (public or private)
--publicize                Make private activities public
```

### List activities in a table

List all activities at once

    > strava

You can also ask only one type of activity (between `Run`, `Ride` or `Swim`).
E.g. If you want only `Run` activities

    > strava --activity Run
    +-------------+-----------+--------------+------------+
    |                         Run                         |
    +-------------+-----------+--------------+------------+
    | Date        | Distance  | Elapsed time | Avg speed  |
    +-------------+-----------+--------------+------------+
    | 01 Oct 2017 | 7.156 km  | 37.53 min    | 11.44 km/h |
    +-------------+-----------+--------------+------------+
    | 23 Sep 2017 | 14.279 km | 73.0 min     | 11.74 km/h |
    | 13 Sep 2017 | 8.252 km  | 43.23 min    | 11.45 km/h |
    | 10 Sep 2017 | 15.62 km  | 87.95 min    | 10.66 km/h |
    | 08 Sep 2017 | 7.597 km  | 48.18 min    | 9.46 km/h  |
    | 02 Sep 2017 | 14.609 km | 77.62 min    | 11.29 km/h |
    +-------------+-----------+--------------+------------+

### List activities in a graph

Display only `Ride` activities in a graph

```
> strava --activity Ride --graph

                2018 - Ride avg speed

19.4|                               *
19.2|
19.0|
18.6|                 *                    *
18.4|
18.2|   *
18.0|                                             *
17.8|
17.6|
17.4|
17.2|
17.0|
16.8+----------*--------------------------------------
     1/2018 2/2018 3/2018 4/2018 5/2018 6/2018 7/2018
```


### Make all private activities public

_warning: you will need a 'write' access token for this to work_

    > strava --publicize
