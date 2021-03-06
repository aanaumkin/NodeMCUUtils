collectgarbage() print("RAM init", node.heap())

require "credentials"
require "dateformatEurope";
require "ntpClock";
require "wlan";

collectgarbage() print("RAM after require", node.heap())

wlan.setup(cred.ssid, cred.password)

wlan.execute(function() ntpc.start("pool.ntp.org", 3600) end)

local function printTime()
	collectgarbage() print("\nRAM in printTime", node.heap())

	df.setEuropeTime(ntpc.current, 3600)

	print("Time:", string.format("%04u-%02u-%02u %02u:%02u:%02d",
		df.year, df.month, df.day, df.hour, df.min, df.sec))
	print("Summer Time:", df.summerTime)
	print("Day of Week:", df.dayOfWeek)
	print("Status:",tostring(wlan), tostring(ntpc))
	print("\n")
end

tmr.alarm(2, 5000, tmr.ALARM_AUTO, printTime)
