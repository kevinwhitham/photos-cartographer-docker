# Use a lightweight Python base image
FROM python:3.11-slim

# Install system dependencies (exiftool, ffmpeg, imagemagick)
# Also install VIM to edit the config file during a run of photos-cartographer
RUN apt-get update && apt-get install -y --no-install-recommends \
    exiftool \
    ffmpeg \
    imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the pre-downloaded files from your local directory into the container
COPY photos-cartographer photos-config-defaults.json ./

# Make the binary executable and test the version output
RUN chmod +x photos-cartographer

# Create mount points for local media and track data
# These directories match photos-config-defaults.json
VOLUME ["/photos", "/gpx", "/library"]

ENV PATH="/app:$PATH"

# Port 8765 for the edit web ui
# Port 8766 for the console web ui. Is this hardcoded or is this port chosen as the first unused port?
# map the external port with docker run ... -p XXXX:8765 -p XXXX:8766 ...
EXPOSE 8765
EXPOSE 8766

# Set the entrypoint to run the web console interface
# hostname -I gets the externally accessible IP of the docker container
# the default IP is localhost 127.0.0.1 which is not accessible outside the container
WORKDIR /photos
ENTRYPOINT ["/bin/bash", "-c", "photos-cartographer console --port 8766 --host $(hostname -I | awk '{print $1}')"]
