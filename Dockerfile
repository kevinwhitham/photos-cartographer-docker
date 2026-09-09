# Use a lightweight Python base image
FROM python:3.11-slim

# Install system dependencies (exiftool, ffmpeg, imagemagick)
RUN apt-get update && apt-get install -y --no-install-recommends \
    exiftool \
    ffmpeg \
    imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the app
COPY photos-cartographer photos-cartographer-start.sh ./
COPY photos-config-defaults.json /default-settings/

# Make the binary executable and test the version output
RUN chmod +x photos-cartographer photos-cartographer-start.sh

# Create a mount point for the default settings file
VOLUME ["/photos-cartographer-config"]

# App will access config settings by a symlink to config file on host
# must do this at build time because /app is owned by root
# but the target file will be copied or mounted at runtime by any user
RUN ln -s /photos-cartographer-config/photos-config-defaults.json /app/photos-config-defaults.json

# Create mount point for media, GPX track, and photo library
# Sub-directories are set in photos-config-defaults.json
VOLUME ["/external"]

ENV PATH="/app:$PATH"

# Port 8765 for the edit web ui
# Port 8766 for the console web ui. Is this hardcoded or is this port chosen as the first unused port?
# map the external port with docker run ... -p XXXX:8765 -p XXXX:8766 ...
EXPOSE 8765
EXPOSE 8766

# Set the entrypoint to run the web console interface
# hostname -I gets the externally accessible IP of the docker container
# the default IP is localhost 127.0.0.1 which is not accessible outside the container
WORKDIR /external/photos
ENTRYPOINT ["/bin/bash", "-c", "/app/photos-cartographer-start.sh"]
