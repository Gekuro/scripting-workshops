local apply_default_headers = require("routes.utils").apply_default_headers
local brand = require('routes.brand')
local bubblegum = require('routes.bubblegum')

local resolvers = {
    get_brands = brand.get_brands,
    get_brand = brand.get_brand,
    post_brand = brand.post_brand,
    update_brand = brand.update_brand,
    delete_brand = brand.delete_brand,

    get_bubblegum_plural = bubblegum.get_bubblegum_plural,
    get_bubblegum = bubblegum.get_bubblegum,
    post_bubblegum = bubblegum.post_bubblegum,
    update_bubblegum = bubblegum.update_bubblegum,
    delete_bubblegum = bubblegum.delete_bubblegum,
}

function resolvers.not_found(ctx)
    apply_default_headers(ctx)
    return { status = 404, json = { error = "Resource not found" } }
end

function resolvers.health(ctx)
    apply_default_headers(ctx)
    return { json = { status = "Good, thanks" } }
end

function resolvers.unhandled_error(ctx)
    apply_default_headers(ctx)
    return { status = 500, json = { error = "Unexpected server error" } }
end

return resolvers
