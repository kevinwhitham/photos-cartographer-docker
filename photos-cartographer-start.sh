#!/bin/bash

# Copy default settings file if it does not exist on the host
cp --no-clobber /default-settings/photos-config-defaults.json /photos-cartographer-config/

# Start the app
photos-cartographer console --port 8766 --host $(hostname -I | awk '{print $1}')
