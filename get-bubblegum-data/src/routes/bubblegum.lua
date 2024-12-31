local db = require "lapis.db"
local models = require "data.models"
local parse_pagination = require("routes.utils").parse_pagination
local apply_default_headers = require("routes.utils").apply_default_headers

local resolvers = {}

function resolvers.get_bubblegum_plural(ctx)
    apply_default_headers(ctx)
    local pagination = parse_pagination(ctx)

    local success, gum = pcall(function()
        return models.Bubblegum:select("LIMIT ? OFFSET ?", pagination.limit, pagination.offset)
    end)
    if not gum or not success then
        return { status = 500, json = { error = "Failed to fetch bubblegum" } }
    end

    return { json = gum }
end

function resolvers.get_bubblegum(ctx)
    apply_default_headers(ctx)

    local id = ctx.params.id
    if not id then
        return { status = 400, json = { error = "ID url parameter not passed" } }
    end

    local success, gum = pcall(function() return models.Bubblegum:find(tonumber(id)) end)
    if not gum or not success then
        return { status = 404, json = { error = "Bubblegum not found" } }
    end

    return { json = gum }
end

function resolvers.post_bubblegum(ctx)
    apply_default_headers(ctx)

    local body = ctx.params
    if not body
    or not body.name
    or not body.flavor
    or not body.brand_id then
        return { status = 400, json = { error = "Invalid input, 'name', 'flavor', and 'brand_id' are required" } }
    end

    local success1, _ = pcall(function() return models.Brands:find(tonumber(body.brand_id)) end)
    if not success1 then
        return { status = 500, json = { error = "Failed to find referenced brand" } }
    end

    local success2, gum = pcall(function() return models.Bubblegum:create({
        name = body.name,
        flavor = body.flavor,
        brand_id = body.brand_id,
        price = body.price
    }) end)

    if not gum or not success2 then
        return { status = 500, json = { error = "Failed to create bubblegum" } }
    end

    return { status = 201, json = gum }
end

function resolvers.update_bubblegum(ctx)
    apply_default_headers(ctx)

    local id = ctx.params.id
    local body = ctx.params
    if not id  then
        return { status = 400, json = { error = "Invalid input, ID is required" } }
    end
    if not body or not type(body) == "table" or next(body) == nil then
        return { status = 400, json = { error = "Invalid request body" } }
    end
    if not body.price
    and not body.flavor_name
    and not body.name
    and not body.brand_id
    and not body.price
    and not body.description then
        return { status = 400, json = { error = "No fields to update in request body" } }
    end

    local success, gum = pcall(function() return models.Bubblegum:find(id) end)
    if not gum or not success then
        return { status = 500, json = { error = "Failed to find bubblegum" } }
    end

    if body.brand_id then
        success = pcall(function() return models.Brands:find(body.brand_id) end)
        if not success then
            return { status = 500, json = { error = "Failed to find brand associated with brand_id" } }
        end
    end

    success = pcall(function() return gum:update({
        name = body.name or gum.name,
        flavor_name = body.flavor_name or gum.flavor_name,
        brand_id = body.brand_id or gum.brand_id,
        description = body.description or gum.description,
        price = body.price or gum.price,
        updated_at = db.raw("now()")
    }) end)
    if not success then
        return { status = 500, json = { error = "Failed to update bubblegum" } }
    end

    return { json = gum }
end

function resolvers.delete_bubblegum(ctx)
    apply_default_headers(ctx)

    local id = ctx.params.id
    if not id then
        return { status = 400, json = { error = "ID url parameter not passed" } }
    end

    local success = pcall(function()
        return models.Bubblegum:find(id):delete()
    end)
    if not success then
        return { status = 500, json = { error = "Failed to delete bubblegum" } }
    end

    return { status = 204 }
end

return resolvers