local lapis = require "lapis"
local config = require "lapis.config"
local cfg = require "config"
local routes = require "routes.routes"

config(cfg)

local app = lapis.Application()
routes.register(app)

return app