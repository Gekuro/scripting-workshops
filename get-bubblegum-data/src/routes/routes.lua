local resolvers = require('routes.resolvers')
local routes = {}

function routes.register(app)
    app:match("/health", resolvers.health)
end

return routes