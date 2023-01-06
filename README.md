# Weffe

[<img src="https://aur.archlinux.org/static/css/archnavbar/aurlogo.png" width="96" />](https://aur.archlinux.org/packages/weffe-git)
[<img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" width="96" />](https://www.buymeacoffee.com/intermezzio)

Weffe is a fast, lightweight webcam video enhancer that can add effects like a blurred background, overlaid images, and text to your webcam feed. This uses ffmpeg and v4l2loopback to output to a virtual webcam, which supports all video calls, including Zoom, WebEx, and Google Meet.

Before | After
:-----:|:------:
![Before Image](demo/no_effect.png) | ![After Image](demo/example_1.png)

## Installation

### Arch
This package is available on the AUR for Arch-based distros as shown below:
```sh
yay -S weffe-git
```

### Other Distros
Clone the repository and install the dependencies below.

Debian:
```sh
sudo apt install ffmpeg v4l2loopback-dkms inotify-tools
```

Ensure that v4l2loopback-dkms is version 0.12.5-1 or later to ensure full functionality.

Then run the command `install.sh` to install this locally.
Note: do not use this method if you are installing it via the AUR.

This can be uninstalled by running `uninstall.sh`.

## Setup

To create a blank virtual webcam (that this script can stream to), first turn on the webcam with the `-a` flag:
```sh
weffe -a
```
_NOTE_: If you ran this command after starting an application like Zoom, you will have to restart Zoom to see the new webcam.

To see what virtual cameras are already initialized, use the `-L` (list) flag:
```sh
weffe -L
```

## Usage

Running `weffe` without arguments streams to a webcam with no effects. Insert one or more command line arguments to add effects to the video. These effects can all be used together unless otherwise specified.

### Blur

This program blurs out pixels on the outer edge of the webcam feed and keeps the center in focus. There are a few options for the shape of this focused section, namely `square`, `rect`, `portrait`, `circle`, and `ellipse`. All blur options fade into the background so there's no hard line separating the blurred video from the face. Different blur shapes can be used depending on how much space should be focused, for example, if multiple people are next to each other on a call. To add a blur, use the `-B` flag. To make the blur stronger, also append the `-S` flag as shown below:

Command | Output
:-----:|:------:
`weffe -B portrait` | ![Portrait blur](demo/blur_portrait.png)
`weffe -SB rect` | ![Rectangle blur](demo/blur_strong_rect.png)

### Meme-ifying a Video

Adding top and bottom text to a video turns your video camera into a large meme, adding white text (with a black border) to the inputted media. Additionally, the `-f` flag allows you to select a font (default Arial, although Impact looks better if you've installed it). Replacing the text with text files allows you to update the text on the video (by changing the file's text) without pausing the webcam stream.

Command | Output
:-----:|:------:
`weffe -t "HELLO WORLD" -b "BOTTOM TEXT" -f "Impact"` or <br /> `weffe -t toptext.txt -b bottomtext.txt` | ![Meme text](demo/meme_text.png)

### Image Overlay

Add an image over your screen - like a picture frame, company logo, or anything you want using the `-w` flag (watermark). This should have background transparency so that your video can still be seen behind it.
Command | Output
:-----:|:------:
`weffe -w static/tux.png` | ![Watermark](demo/with_tux.png)

### Rotation

This script supports continuously rotating your webcam video over time. Adding the `-r` flag continously rotates the stream at a fixed rate over time. For example, the following command rotates the input video stream in circles over time:

However, you can also create fancier rotations by making rotation angle a function of time using the `-z` flag. The syntax for this rotation can be found [here](https://ffmpeg.org/ffmpeg-all.html#Examples-136). The below example shows how to make a video stream oscillate like a pendulum using a sine function.

Command | Output
:-----:|:------:
`weffe -r` | ![Rotate](demo/rotate.png)
`weffe -z "1/2*sin(PI/2*t)"` | ![Pendulum](demo/pendulum.png)


### Looping a Video to the Webcam

Save a video file in the directory. Most video formats should work with this script. I recommend using [Guvcview](http://guvcview.sourceforge.net/) for taking videos using the webcam.  
Then, run the video looper script to generate a lengthened video and stream it to `/dev/video7`. This will create a longer mp4 file that gets streamed to the webcam. By default, the video gets duplicated and played in reverse after it completes so that there is no "jump" from the last frame to the first. To remove this functionality (and never play the video in reverse), also add the `-s` (skip processing) flag.
```sh
weffe -v your_video.mp4
weffe -sv dont_reverse_this_video.mp4
```

### Monitor Output (beta)

This option checks if the virtual webcam is being fed into an application (e.g. video calling software) and runs the webcam on demand. This feature is good if there are a lot of effects on the webcam as it can save computer resources while video calling platforms are off. In the off time, it streams a blank color to the webcam. However, it is still being tested and does not work when applications regularly probe the webcam to check if it's streaming (e.g. Discord opens and closes the webcam approx. every 3 seconds). This option requires the optional `inotify-tools` dependency.

```sh
weffe -M
```

### Extra Options

For more options, run the following command (or read the help page):
```sh
weffe -h
```

## More Examples

Command | Output
:-----:|:------:
`weffe -B portrait -w static/solid_frame.png` | ![Example 1](demo/example_1.png)
`weffe -B rect -t "what i call" -b "a living meme" -f "Impact"` | ![Example 2](demo/example_2.png)

## How to Pronounce "Weffe"

Most software names or commands don't include this but it seems important to know how to pronounce "weffe" if it ever comes up. Weffe is short for **W**ebcam **Effe**cts, and there are two accepted ways to pronounce it. One is to pronounce it like the first part of the word "effects" with the letter "w" in front, e.g. as if it were spelled "weffè", or "weh-FEH". Other accepted pronunciations include pronouncing it with a long e sound at the end, like "WEH-fee" or with an a sound at the end, like "WEH-fay".
