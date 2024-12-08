local lapis = require "lapis"
local app = lapis.Application()

app:match("/health", function(self)
  return "Good, thanks"
end)

return app