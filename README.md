# photos-cartographer-docker
Docker container for photos-cartographer

The container needs two mount points to the host filesystem.

One mount provides access photos, GPX files and the photo library. The structure of this mount should have these sub-directories:


`photos` - photos to modify

`gpx` - GPX files

`library` - the library to merge into


Create a directory on your host system with these sub-directories or symlinks with those names to the desired directories.
Mount this directory inside the container as `/external`

The second mount provides access to the default configuration file. This file is copied each run to the working directory as `.photos-ingest/photos-00-config.json` Therefore it is convenient to modify the default settings file with options that do not change from run to run such as the camera names, time offsets, directories, etc. Mount a directory on the host system to keep the default config file inside the container at `/photos-cartographer-config`.
