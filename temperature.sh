#!/bin/sh
date > /tmp/temperature
curl --silent -L -c /tmp/cookie.jar 'http://www.accuweather.com/m/en-us/ES/Cataluna/Barcelona/Quick-Look.aspx' | 
	grep ctl00_CPH1_lblCurrentTemp | 
	sed 's/.*>\([0-9]*\)&.*/\1/' |
        tee -a /tmp/temperature
exit 0
