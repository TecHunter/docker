# OctoPrint in Docker

This repository contains everything you need to run [Octoprint](https://github.com/foosel/OctoPrint) in a docker environment.

# Getting started

```
# search for you 3D printer serial port (usually it's /dev/ttyUSB0 or /dev/ttyACM0)
ls /dev | grep tty

docker run -d -v ./config:/home/octoprint/.octoprint --device /dev/ttyACM0:/dev/ttyACM0 -p 5000:5000 --name octoprint techunter/octoprint
```

You can then go to http://localhost:5000


# Additional tools

## FFMPEG

Octoprint allows you to make timelapses using an IP webcam and ffmpeg. It is installed in `/opt/ffmpeg`

## Cura Engine

Octoprint allows you to import .STL files and slice them directly in the application. For this you need to upload the profiles that you want to use (you can export them from Cura). Cura Engine is installed in `/opt/cura/CuraEngine`.
