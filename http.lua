-- ESP8266-HTTP Library
-- Written 2014 by Tobias Mädel (t.maedel@alfeld.de)
-- Licensed unter MIT

local moduleName = ... 
local M = {}
_G[moduleName] = M
local inputbuffer = ""
function M.get(host, port, url, args, callback)
	conn=net.createConnection(net.TCP, false) 
	inputbuffer = ""
	local argsstr = ""
	argsstr = M.url_encode_table(args)
	if (argsstr ~= "") then
		argsstr = "?"..argsstr
	end
	conn:on("receive", function(conn, payload)
		inputbuffer = inputbuffer..payload
	end)
	conn:on("disconnection", function(conn) 
		conn = nil
		inputbuffer = string.sub(inputbuffer,string.find(inputbuffer,"\r\n\r\n") + 4)
		callback(inputbuffer)
	end)
	conn:connect(port,host)
	conn:send("GET /"..url..argsstr.." HTTP/1.0\r\n"..
			  "Host: "..host.."\r\n"..
			  "Connection: close\r\n"..
			  "Accept-Charset: utf-8\r\n"..
			  "Accept-Encoding: \r\n"..
			  "Accept: */*\r\n\r\n")
end
function M.url_encode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w %-%_%.%~])",
		    function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str	
end
function M.url_encode_table(t)
	local argts = {}
	local i = 1
	for k, v in pairs(t) do
		argts[i]=M.url_encode(k).."="..M.url_encode(v)
		i=i+1
	end
	return table.concat(argts,'&')
end
return M