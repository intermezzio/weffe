# Webcam Video Effects 

This series of scripts can stream a video or add photo effects to your webcam. This then sends that edited video stream to a new webcam, specifically `/dev/video2`. After the script runs, you can select the extra webcam as your video source on a zoom call, webex call, or any video call.

## Requirements

This shell script uses ffmpeg and v4l2loopback-dkms for video manipulation, which is available on Windows, MacOS, and Linux.
However, the script to stream to a webcam only works on Linux.
```sh
sudo apt-get install v4l2loopback-dkms
```

## Setup

To create a blank virtual webcam (that this script can stream to), run the following command:
```sh
sudo modprobe v4l2loopback video_nr=2
```
Since this command needs to be run every time you restart your computer, it has been aliased with the script below:
```sh
./turn_webcam_on.sh
```

## Usage

### Meme-ifying a Video

Adding top and bottom text to a video turns your video camera into a large meme, adding white text (with a black border) to the inputted media. Additionally, the `-f` flag allows you to select a font (default Arial, although Impact looks better if you've installed it).
```sh
./video_looper_complete.sh -t "TOP TEXT HERE" -b "BOTTOM TEXT HERE" -f "Impact"
```

### Image Overlay

Add an image over your screen - like a picture frame, company logo, or anything that you want using the `-w` flag (watermark). This should have transparency so that your video can still be seen behind it.
```sh
./video_looper_complete.sh -w company_logo.png
```

### Rotation

This script supports continuously rotating your webcam video over time. Adding the `-r` flag continously rotates the stream at a fixed rate over time. For example, the following command rotates the input video stream in circles over time:
```sh
./video_looper_complete.sh -r
```

However, you can also create fancier rotations by making rotation angle a function of time using the `-z` flag. The syntax for this rotation can be found [here](https://ffmpeg.org/ffmpeg-all.html#Examples-136). The below example shows how to make a video stream oscillate like a pendulum using a sine function.
```sh
./video_looper_complete.sh -z "1/2*sin(PI/2*t)"
```

### Looping a Video to the Webcam

Save a video file in the directory. Most video formats should work with this script. I recommend using [Guvcview](http://guvcview.sourceforge.net/) for taking videos using the webcam.  
Then, run the video looper script to generate a lengthened video and stream it to `/dev/video2`.
```sh
./video_looper_complete.sh -v your_video.mp4
```
This will create a longer mp4 file that gets streamed to the webcam. By default, the video gets duplicated and played in reverse after it completes so that there is no "jump" from the last frame to the first. To remove this functionality (and never play the video in reverse), add the `-s` flag.
```sh
./video_looper_complete.sh -sv your_unprocessed_video.mp4
```

### Tips for Looping a Video

This script uses your video at normal speed and in reverse, so avoid talking or moving quickly in the video. Also, try to stay still during the first and last seconds of your video so that there is a gradual transition when the clip repeats. Use a video that's at least 25 seconds long.

It's easy to switch video streams within Zoom or another video conferencing software, and if you use this script, it's very easy to generate a new video to stream each day you're on a call. I would recommend taking a new video every day and using that new video as necessary, since you may need to switch back and forth between this fake webcam and a real one if you need to speak during your call.

### Extra Options

For more options, run the following command (or read the help page):
```sh
./video_looper_complete.sh -h
```
