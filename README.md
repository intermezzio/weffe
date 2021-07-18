# Webcam Video Effects 

This series of scripts can stream a video or add photo effects to your webcam. This then sends that edited video stream to a new webcam, specifically `/dev/video2`. After the script runs, you can select the extra webcam as your video source on a zoom call, webex call, or any video call.

## Requirements

This shell script uses ffmpeg and v4l2loopback-dkms for video manipulation, which is available on Windows, MacOS, and Linux.
However, the script to stream to a webcam only works on Linux.

Debian:
```sh
sudo apt-get install v4l2loopback-dkms
```
Arch:
```sh
sudo pacman -S v4l2loopback-dkms
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

Calling the script `video_looper_complete.sh` without arguments streams to a webcam with no effects. Insert one or more command line arguments to add effects to the video. These effects can all be used together unless otherwise specified.

### Blur

There are multiple ways to blur the video input, namely `vignette`, `vignette-strong`, `box`, `box-strong`, `doublebox`, and `doublebox-strong`. The vignette option is not blurred in the center but blurs as approaching the sides. The box options have one bounding box for blurring the video, while the doublebox options have two to make a "fade out" into the blurred background. The strong options have stronger blurs than the normal blur options. To add a blur, use the `-B` flag as shown below:
```sh
./video_looper_complete.sh -B vignette

```
_NOTE_: As of right now, blur CANNOT be used with the watermark feature below. This may change in future versions.

### Meme-ifying a Video

Adding top and bottom text to a video turns your video camera into a large meme, adding white text (with a black border) to the inputted media. Additionally, the `-f` flag allows you to select a font (default Arial, although Impact looks better if you've installed it).
```sh
./video_looper_complete.sh -t "TOP TEXT HERE" -b "BOTTOM TEXT HERE" -f "Impact"
```
_NEW_: If you want to edit the text while running the script, replace the text arguments with filenames. The text in the files can be updated to change the words on the video stream in real time.
```sh
./video_looper_complete.sh -t toptext.txt -b bottomtext.txt
```

### Image Overlay

Add an image over your screen - like a picture frame, company logo, or anything that you want using the `-w` flag (watermark). This should have transparency so that your video can still be seen behind it.
```sh
./video_looper_complete.sh -w static/ink_black_frame.png
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
