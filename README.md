Slack-Metabot
=============

[![Add to Slack](https://platform.slack-edge.com/img/add_to_slack@2x.png)](http://slack-metabot.herokuapp.com)

Or roll your own ...

[![Build Status](https://travis-ci.org/dblock/slack-metabot.svg)](https://travis-ci.org/dblock/slack-metabot)
[![Code Climate](https://codeclimate.com/github/dblock/slack-metabot/badges/gpa.svg)](https://codeclimate.com/github/dblock/slack-metabot)
[![Dependency Status](https://gemnasium.com/dblock/slack-metabot.svg)](https://gemnasium.com/dblock/slack-metabot)

A generic meta bot for slack.

## Installation

Create a new Bot Integration under [services/new/bot](http://slack.com/services/new/bot). Note the API token.
You will be able to invoke metabot by the name you give it in the UI above.

Run `SLACK_API_TOKEN=<your API token> GAMEBOT_SECRET=secret foreman start`

## Production Deployment

See [DEPLOYMENT](DEPLOYMENT.md)

## Usage

TODO

## Contributing

This bot is built with [slack-ruby-bot](https://github.com/dblock/slack-ruby-bot). See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2016, Daniel Doubrovkine, Artsy and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
