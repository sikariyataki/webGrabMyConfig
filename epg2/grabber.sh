#!/bin/bash

echo "WebGrabber Plus launched for epg2.xmltv file"
#wget  --post-data "token=a1zc9d81aw14ezws414n7uvsnz2xio&user=uxepp2gjx5ch4eveufj8fo8jmcm6we&device=sm-g935f&title=WebGrabber+message&message=WebGrabber+extrating+launched." -qO-
cd /home/pi/wg++
mono WebGrab+Plus.exe "/home/pi/wg++/epg2"
#sudo cp "./epg/epg.xmltv" ../../hts/
sudo cp "./epg2/epg2.xmltv" /home/pi/toshiba/TvGuide
#wget  --post-data "token=a1zc9d81aw14ezws414n7uvsnz2xio&user=uxepp2gjx5ch4eveufj8fo8jmcm6we&device=sm-g935f&title=WebGrabber+message&message=WebGrabber+grabbing+finiched+for+epg+file." -qO-

