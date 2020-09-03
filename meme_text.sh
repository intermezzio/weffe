
ffmpeg -stream_loop -1 -re -i "$1" -vf "drawtext=font='Arial': \
	text='IS THIS': x=(w-tw)/2: y=(h-text_h)/8: \
	fontsize=64: borderw=4: fontcolor=AntiqueWhite, \
	drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf:\
	text='A MEME?':x=(w-tw)/2:y=7*(h-text_h)/8: \
	fontsize=64: borderw=4: fontcolor=AntiqueWhite, \
	rotate=2*PI*t/6, format=yuv420p[v]" \
	-map 0:v -f v4l2 "/dev/video2"

	# "[in]drawtext=fontsize=20:fontcolor=White:fontfile='/Windows/Fonts/arial.ttf':text='onLine1':x=(w)/2:y=(h)/2, drawtext=fontsize=20:fontcolor=White:fontfile='/Windows/Fonts/arial.ttf':text='onLine2':x=(w)/2:y=((h)/2)+25, drawtext=fontsize=20:fontcolor=White:fontfile='/Windows/Fonts/arial.ttf':text='onLine3':x=(w)/2:y=((h)/2)+50[out]"