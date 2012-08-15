## About

This collector forms part of the Data Insight Platform. It collects visits
and visitors for DirectGov and BusinessLink from a Google Drive spreadsheet
and broadcasts the results as messages.

## Key

The routing keys this collector broadcasts on are:

    googledrive.visits.weekly
    googledrive.visitors.weekly

## Format

The message is JSON and follows the following strcuture.

    {
      "envelope":{
        "collected_at":"2012-07-31T10:46:25+01:00",
        "collector":"nongovuk_reach"
       },
       "payload":{
          "value": 12345,
          "site": "directgov",
          "start_at": "2012-04-01T00:00:00+00:00",
          "end_at": "2012-04-07T00:00:00+00:00",
       }
    }

## Dependencies

Bundler manages the ruby dependencies so you'll want a quick:

    bundle install

If you're using the broadcast command you'll need a message queue
listening. This defaults to listening on localhost on 5672 but can be
overridden with the AMQP environment variable.

## Usage

The first run requires the Oauth token from Google for the given
application. Once you have that you can run:

    bundle exec bin/collector --token={auth token from Google} --metric={visits|visitors} --site={directgov|businesslink} print

Full help details can be found with:

    bundle exec bin/narrative-collector help
