# photos-cartographer-docker
Docker container for photos-cartographer

The container uses a single mount to access the photos to modify, the GPX files and the photo library.
The structure of the mount should have these sub-directories:


`photos` - photos to modify

`gpx` - GPX files

`library` - the library to merge into


Create a directory on your host system with these sub-directories or symlinks to those directories.
Mount this directory inside the container as `/external`
