local resolvers = require('routes.resolvers')
local helpers = require("lapis.application")
local respond_to = helpers.respond_to
local capture_errors = helpers.capture_errors

local routes = {}

function routes.register(app)
    app:match("brand", "/brand/:id", respond_to({
        GET = resolvers.get_brand,
        PATCH = resolvers.update_brand,
        DELETE = resolvers.delete_brand
    }))
    app:match("brand_no_id", "/brand", respond_to({
        GET = resolvers.get_brands,
        POST = resolvers.post_brand
    }))

    app:match("bubblegum", "/bubblegum/:id", respond_to({
        GET = resolvers.get_bubblegum,
        PATCH = resolvers.update_bubblegum,
        DELETE = resolvers.delete_bubblegum
    }))
    app:match("bubblegum_no_id", "/bubblegum", respond_to({
        GET = resolvers.get_bubblegum_plural,
        POST = resolvers.post_bubblegum
    }))

    app:match("health", "/health", respond_to({
        GET = resolvers.health
    }))
    app:match("server_error", capture_errors(resolvers.unhandled_error))
    app:match("*", resolvers.not_found)
end

return routes