require "wlan"
require "ntp"
require "dateformat";

local function printTime(ts) 
	df:setTime(ts) 
	print("NTP Time:", df)
end

ntp:registerResponseCallback(printTime)

wlan:connect("Maciej Miklas’s iPhone", "mysia2pysia", ntp.requestTime)