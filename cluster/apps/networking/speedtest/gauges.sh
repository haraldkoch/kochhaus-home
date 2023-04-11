#!/usr/bin/with-contenv bash

# This script overwrites the default (example-singleServer-full.html) page
# with the pretty version.

cat /config/www/example-singleServer-gauges.html | sed -e 's/LibreSpeed Example/Koch Haus Speed Test/' > /config/www/index.html
