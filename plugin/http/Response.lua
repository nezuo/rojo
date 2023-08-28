local HttpService = game:GetService("HttpService")

local msgpack = require(script.Parent.Parent.msgpack)

local stringTemplate = [[
Http.Response {
	code: %d
	body: %s
}]]

local Response = {}
Response.__index = Response

function Response:__tostring()
	return stringTemplate:format(self.code, self.body)
end

function Response.fromRobloxResponse(response)
	local self = {
		body = response.Body,
		code = response.StatusCode,
		headers = response.Headers,
	}

	return setmetatable(self, Response)
end

function Response:isSuccess()
	return self.code >= 200 and self.code < 300
end

function Response:json()
	local startedAt = os.clock()

	local value = HttpService:JSONDecode(self.body)

	print("JSON took:", os.clock() - startedAt)

	return value
end

function Response:msgpack()
	local startedAt = os.clock()

	local value = msgpack.decode(self.body)

	print("msgpack took:", os.clock() - startedAt)

	return value
end

return Response
