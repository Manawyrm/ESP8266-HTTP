-- ESP8266-HTTP Library
-- Written 2014 by Tobias Mädel (t.maedel@alfeld.de)
-- Licensed unter MIT

-- Download a file
tmr.wdclr()

httpDL = require("httpDL")
collectgarbage()

--               IP/Host        URL 								 Destination  Finished Callback
httpDL.download("10.4.0.5", 80, "/api/esp8266/lichtTreppe/main.lua", "main2.lua", function (payload)
	-- Finished downloading
end)

httpDL = nil
package.loaded["httpDL"]=nil
collectgarbage()


-- sending a GET request and get the return value

tmr.wdclr()
http = require("http")
collectgarbage()
--        IP/Host        URL 								  GET Arguments  Finished Callback
http.get("10.4.0.5", 80, "/api/esp8266/lichtTreppe/main.lua", {foo = "bar"}, function (payload)
	print(payload)
end)
http = nil
package.loaded["http"]=nil
collectgarbage()