require "dateformatEurope";
require "dateformatAmerica";

testCnt = 0;
local function parseDate(expDate)
	local _, _, expYearStr, expMonthStr, expDayStr, expHourStr, expMinStr, expSecStr =
		string.find(expDate, "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
	local expYear, expMonth, expDay = tonumber(expYearStr), tonumber(expMonthStr), tonumber(expDayStr)
	local expHour, expMin, expSec = tonumber(expHourStr), tonumber(expMinStr), tonumber(expSecStr)
	return 	expYear, expMonth, expDay, expHour, expMin, expSec
end

function format()
	return string.format("%04u-%02u-%02u %02u:%02u:%02d", df.year, df.month, 
		df.day, df.hour, df.min, df.sec)
end

function testUTC()
	for line in io.lines("test/unit/data/datesUTC.csv") do
		testCnt = testCnt + 1
		local _, _, tsStr, expDate = string.find(line, "(%d+),(.*)")
		local ts = tonumber(tsStr)
		local expYear, expMonth, expDay, expHour, expMin, expSec = parseDate(expDate);
		df.setTime(ts)
		local fromated = format()

		local msg =  tsStr.." -> "..expDate.." ~= "..fromated
		assert(fromated == expDate, msg)
		assert(df.summerTime == nil, msg)
		assert(df.year == expYear, msg)
		assert(df.month == expMonth, msg)
		assert(df.day == expDay, msg)
		assert(df.hour == expHour, msg)
		assert(df.min == expMin, msg)
		assert(df.sec == expSec, msg)
	end
end

function testLocal(location, utcOffset, timeFunction)
	for line in io.lines("test/unit/data/dates"..location..".csv") do
		testCnt = testCnt + 1
		local _, _, utcSecTxt, expDate, expDls = string.find(line, "(%d+),(.*),(%d)")
		local utcSec = tonumber(utcSecTxt)
		local expYear, expMonth, expDay, expHour, expMin, expSec = parseDate(expDate);
		timeFunction(utcSec, utcOffset)
		local fromated = format()
		local summer = (df.summerTime and "Summer" or "Winter")
		local expSummer = (expDls == "1" and "Summer" or "Winter")
		local msg =  location.." -> "..utcSecTxt.." -> "..expDate.."("..expSummer..") ~= "..fromated.."("..summer..")"
		assert(fromated == expDate, msg)
	end
end

function testEurope(city, utcOffset)
	local location = "Europe_"..city
	local timeFunction = function(ts, utcOffset) return df.setEuropeTime(ts, utcOffset) end
	testLocal(location, utcOffset, timeFunction)
end

function testAmerica(city, utcOffset)
	local location = "America_"..city
	local dateFactory = function(ts, utcOffset) return df.setAmericaTime(ts, utcOffset) end
	testLocal(location, utcOffset, dateFactory)
end

print("Executing tests....")
testUTC()
testEurope("London", 0)
testEurope("Warsaw", 3600)
testEurope("Bucharest", 7200)
testAmerica("Los_Angeles", -28800)

print("Done - Executed "..testCnt.." tests, all OK")
