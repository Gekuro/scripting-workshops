local resolvers = require('routes.resolvers')
local respond_to = require('lapis.respond_to')
local routes = {}

function routes.register(app)
    app:match("health", "/health", respond_to({
        GET = resolvers.health
    }))
    app:match("brand", "/brand/:id", respond_to({
        GET = resolvers.get_brand,
        POST = resolvers.post_brand,
        UPDATE = resolvers.update_brand,
        DELETE = resolvers.delete_brand
    }))
    app:match("bubblegum", "/bubblegum/:id", respond_to({
        GET = resolvers.get_bubblegum,
        POST = resolvers.post_bubblegum,
        UPDATE = resolvers.update_bubblegum,
        DELETE = resolvers.delete_bubblegum
    }))
end

return routes