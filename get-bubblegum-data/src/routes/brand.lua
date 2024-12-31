local db = require "lapis.db"
local models = require "data.models"
local parse_pagination = require("routes.utils").parse_pagination
local apply_default_headers = require("routes.utils").apply_default_headers

local resolvers = {}

function resolvers.get_brands(ctx)
    apply_default_headers(ctx)
    local pagination = parse_pagination(ctx)

    local success, brands = pcall(function() return models.Brands:select(
        "LIMIT ? OFFSET ?",
        pagination.limit,
        pagination.offset
    ) end)
    if not brands or not success then
        return { status = 500, json = { error = "Failed to fetch brands" } }
    end

    return { json = { brands = brands } }
end

function resolvers.get_brand(ctx)
    apply_default_headers(ctx)

    local id = ctx.params.id
    if not id then
        return { status = 400, json = { error = "ID url parameter not passed" } }
    end

    local success, brand = pcall(function() return models.Brands:find(id) end)
    if not brand or not success then
        return { status = 404, json = { error = "Brand with the provided ID not found" } }
    end

    return { json = brand }
end

function resolvers.post_brand(ctx)
    apply_default_headers(ctx)

    local body = ctx.params
    if not body or not body.name or not body.country then
        return { status = 400, json = { error = "Invalid input, 'name' and 'country' is required" } }
    end

    local brand = models.Brands:create({
        name = body.name,
        country = body.country
    })

    if not brand then
        return { status = 500, json = { error = "Failed to create brand" } }
    end

    return { status = 201, json = brand }
end

function resolvers.update_brand(ctx)
    apply_default_headers(ctx)

    local id = ctx.params.id
    local body = ctx.params
    if not id then
        return { status = 400, json = { error = "Invalid input ID is required" } }
    end
    if not body or not type(body) == "table" or next(body) == nil then
        return { status = 400, json = { error = "Invalid request body" } }
    end
    if not body.country and not body.name then
        return { status = 400, json = { error = "No fields to update in request body" } }
    end

    local success, brand = pcall(function() return models.Brands:find(id) end)
    if not brand or not success then
        return { status = 500, json = { error = "Failed to find brand" } }
    end

    success = pcall(function() return brand:update({
        name = body.name or brand.name,
        country = body.country or brand.country,
        updated_at = db.raw("now()")
    }) end)
    if not success then
        return { status = 500, json = { error = "Failed to update brand" } }
    end

    return { json = brand }
end

function resolvers.delete_brand(ctx)
    apply_default_headers(ctx)

    local id = tonumber(ctx.params.id)
    if not id then
        return { status = 400, json = { error = "ID url parameter not passed" } }
    end

    local success = pcall(function()
        return models.Brands:find(id):delete()
    end)
    if not success then
        return { status = 500, json = { error = "Failed to find brand" } }
    end

    return { status = 204 }
end

return resolvers