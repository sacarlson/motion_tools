# Motion_tools
Copyright:: Copyright (c) 2014 Scott Carlson  sacarlson@ipipi.com

## What is Motion_tools
Motion_tools is a group of scripts writen to support the use of motion a V4L capture program supporting motion detection.
more details on the program motion can be seen here http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome.
The problem I had was after some time motion would capture too many images for me to have time to look at to even check my security images captured.
so to shorten the needed time to view the results I made this group of scripts and tools to clean up no longer needed files over time:

##Features:
* Convert motion V4L captured jpg images into a video that runs at 10 times real time and play them.
* Create shorter event driven videos that only contain windows of time after an event of no motion detection over some time frame and then play them to view.
* Create short video of just the last 5 hours to look back at only what happend recently that will play back at 10 times real time and then play the video.
* some added scripts to auto start at boot and to clean up delete old images after a certain number of days to save disk space.
* an example of how to setup crontab to start motion with desired configs at boot and for file clean up script. 
* a few other scripts that I wrote when I was developing the above, that are not well documented, that can be used as reference or for custom uses.


## Details of what's in Motion_tools
##make_vid_events.sh 
with this script we create a video of each event with the time of each event clip depending on the event_image_count
we now capture at 3 images per secound so 100 images will be about 33 secounds for each event played back at 10 times so 3.3 secounds to see.
An event is considered a time when there has been no motion captured for some specified amount of time.  I choose 30 minutes as the default lag time
as we now call it, as in a normal day I will triger an event every 20 minutes or less as long as I am present in the room.  So I only want to view when there 
has been no activity and sudenly there is some, like when someone first enters the room after no one was in the room for the last 30 minutes.
video is also set to playback at 30fps so video plays back at about 10X realtime speed due to capture rate that is set at 3fps.
for me this makes 24 hours play back in 10 secounds so I can quickly see if anyone other than myself entered my room on this day or window of time.
the video is then opened to be viewed in vlc after it's creation.

##make_video_last5hours.sh
in this script we create a video of all what motion has captured over the last 5 hours.  it plays back again at 10 times realtime.
This provides me a view of most everything that happend in the average time that I leave my room.  At some point I will add a param
that will specify how many hours you want to look back when generating the video.  But at present it's hard coded to 5 hours.  I have 
this setup as a shortcut so I can double click it to run it.  the video is then opened to be viewed in vlc after it's creation.

##make_video_today.sh
this script creates a video of all what motion has captured within the last 24 hours. it plays back again at 10 times realtime.
 the video is then opened to be viewed in vlc after it's creation.

##last_event.sh
This opens the last event captured in an image viewer that you can move forward and reverse frame by frame to see details of last event.
the event is the setup with the rules same as make_vid_events.sh.  this should be edited to include param that specifies how many events to go
back to start view.  I'll do that later if needed.  But at this time I just view the video in most cases so don't really need it. 

##License:
 GPLv3 see http://www.gnu.org for details

## dependencies
 This was writen and was setup to run on Linux mint or Ubuntu
 you will need to install the motion and vlc, realpath packages to capture and view video with and to setup paths to work from symbolic links.
 apt-get install motion vlc realpath
 It should also run on most any linux that supports motion and bash scripts.

## To install
 I locate the scripts in a directory of ~/motion in my home directory but you can locate them in any user location you desire to setup.
 the scripts will auto create subdirs in the ~/motion directory when they are ran for the first time to save the motion images and create linked
 sequences to generate the video from.  The scripts are writen to all run from the same directory as they all use the same relitive file locations for images.
 
