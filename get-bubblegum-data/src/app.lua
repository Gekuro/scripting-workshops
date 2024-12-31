local lapis = require "lapis"
local routes = require "routes.routes"

local app = lapis.Application()
routes.register(app)

return app
