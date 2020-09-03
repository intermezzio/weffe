# Webcam Video Effects 

This series of scripts can stream a video or add photo effects to your webcam. This then sends that edited video stream to a new webcam, specifically `/dev/video2`. After the script runs, you can select the extra webcam as your video source on a zoom call, webex call, or any video call.

## Requirements

This shell script uses ffmpeg and v4l2loopback-dkms for video manipulation, which is available on Windows, MacOS, and Linux.
However, the script to stream to a webcam only works on Linux.
```sh
sudo apt-get install v4l2loopback-dkms
```

## Usage

### Setup

To create a blank virtual webcam (that this script can stream to), run the following command:
```sh
sudo modprobe v4l2loopback video_nr=2
```
### Looping a Video
Clone this repo and save a video file in this directory. Most video formats should work with this script. I recommend using [Guvcview](http://guvcview.sourceforge.net/) for taking videos using the webcam.

Then, run the video looper script to generate a lengthened video and stream it to `/dev/video2`.
```
sh video_looper_complete.sh -v your_video.mp4
```
This will create a longer mp4 file that gets streamed to the webcam. By default, the video gets duplicated and played in reverse after it completes so that there is no "jump" from the last frame to the first. To remove this functionality (and never play the video in reverse), add the `-s` flag.

### Meme-ifying a Video

Adding top and bottom text to a video turns your video camera into a large meme, adding white text (with a black border) to the inputted media.
```
sh video_looper_complete.sh -t "TOP TEXT HERE" -b "BOTTOM TEXT HERE" -f "Impact"
```
Additionally, the `-f` flag allows you to select a font (default Arial, although Impact looks better if you've installed it).

### Image Overlay

Add an image over your screen - like a picture frame, company logo, or anything that you want using the `-w` flag (watermark). This should have transparency so that your video can still be seen behind it.
```
sh video_looper_complete.sh -w company_logo.png
```

For more options, run the following command (or read the help page):
```
sh video_looper_complete.sh -h
```

## What this program does

This program first accepts an input video and processes it. To prevent the video from looking choppy when the clip ends and restarts, this script plays the video in reverse each time the video completes. This way, the video is duplicated, reversed, and concatenated to itself to create a larger video that is twice as long as the original. This processing takes place in the `video_looper_complete.sh` script.
The video is then streamed to a virtual webcam using ffmpeg. This stream is created with the `webcam_loop.sh` script. If you already have a video (any format) that you want to stream to your webcam, you can just run this script:
```
sh video_looper_complete.sh -sv your_unprocessed_video.mp4
```

## Tips

This script uses your video at normal speed and in reverse, so avoid talking or moving quickly in the video. Also, try to stay still during the first and last seconds of your video so that there is a gradual transition when the clip repeats. Use a video that's at least 25 seconds long.

It's easy to switch video streams within Zoom or another video conferencing software, and if you use this script, it's very easy to generate a new video to stream each day you're on a call. I would recommend taking a new video every day and using that new video as necessary, since you may need to switch back and forth between this fake webcam and a real one if you need to speak during your call.
