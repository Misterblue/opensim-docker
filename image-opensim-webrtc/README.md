# image-opensim-webrtc

This builds an image of the master branch of the OpenSimulator repository
that includes the addon-module [os-webrtc-janus].
That is, this is OpenSimulator with WebRTC voice.

There will be additional configuration for voice so refer to [os-webrtc-janus].

There are two configurations supplied for this image:

`config-standalone` runs OpenSimulator as a standalone instance
that has both the region simulators and grid services in a local
instance.
This is great for testing or just getting confortable with what
OpenSimulator can do.

`config-osgrid` has the [OSGrid] connection configuration for
hosting a region connected to that grid.
You MUST change `Regions.ini` to a allocated location in
that grid.
Notice that all the .ini files supplied are the defaults
from the OpenSimulator distribution and all the [OSGrid]
configuration is done in `Final.ini`.

[OSGrid]: https://osgrid.org
[OpenSimulator]: http://opensimulator.org
[os-webrtc-janus]: https://github.com/Misterblue/os-webrtc-janus
