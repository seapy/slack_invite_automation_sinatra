#!/bin/bash

export DISPLAY=:99
/usr/bin/Xvfb :99 -screen 0 1024x768x24 -ac &
bundle exec foreman start
