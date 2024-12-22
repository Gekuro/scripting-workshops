local models = require "data.models"
local resolvers = {}

local DEFAULT_PAGE_LIMIT = 20
local DEFAULT_PAGE_LIMIT_CAP = 120

local function applyDefaultHeaders(ctx) 
    ctx.res.headers["Content-Type"] = "application/json"
    ctx.res.headers["Server"] = "bubble-pop/" .. (os.getenv("APP_VERSION") or "unknown")
    ctx.res.headers["Cache-Control"] = "no-cache"
end

local function parse_pagination(ctx)
    local limit = DEFAULT_PAGE_LIMIT
    if ctx.body.limit and tonumber(ctx.body.limit) then
        limit = tonumber(ctx.body.limit)
        if limit < 1 then
            limit = DEFAULT_PAGE_LIMIT
        elseif limit > DEFAULT_PAGE_LIMIT_CAP then
            limit = DEFAULT_PAGE_LIMIT_CAP
        end
    end

    local page = 1
    if ctx.body.page and tonumber(ctx.body.page) then
        page = tonumber(ctx.body.page)
        if page < 1 then
            page = 1
        end
    end

    return { limit = limit, offset = (page - 1) * limit }
end

function resolvers.get_brands(ctx)
    applyDefaultHeaders(ctx)
    local pagination = parse_pagination(ctx)

    local success, brands = pcall(models.Bubblegum:select("LIMIT ? OFFSET ?", pagination.limit, pagination.offset))
    if not brands or not success then
        return { status = 500, json = { error = "Failed to fetch brands" } }
    end

    return { json = brands }
end

function resolvers.get_brand(ctx)
    applyDefaultHeaders(ctx)

    local id = ctx.params.id
    if not id then
        return resolvers.get_brands(ctx)
    end

    local success, brand = pcall(models.Brands:find(id))
    if not brand or not success then
        return { status = 404, json = { error = "Brand with the provided ID not found" } }
    end

    return { json = brand }
end

function resolvers.post_brand(ctx)
    applyDefaultHeaders(ctx)

    local body = ctx.body
    if not body or not body.name then
        return { status = 400, json = { error = "Invalid input, 'name' is required" } }
    end

    local success, brand = pcall(models.Brands:create({
        name = body.name
    }))
    if not brand or not success then
        return { status = 500, json = { error = "Failed to create brand" } }
    end

    return { status = 201, json = brand }
end

function resolvers.update_brand(ctx)
    applyDefaultHeaders(ctx)

    local id = ctx.params.id
    local body = ctx.body
    if not id or not body then
        return { status = 400, json = { error = "Invalid input ID is required" } }
    end

    local success, brand = pcall(models.Brands:find(id))
    if not brand or not success then
        return { status = 500, json = { error = "Failed to find brand" } }
    end
    
    local success2 = pcall(brand:update(body))
    if not success2 then
        return { status = 500, json = { error = "Failed to update brand" } }
    end

    return { json = brand }
end

function resolvers.delete_brand(ctx)
    applyDefaultHeaders(ctx)

    local id = ctx.params.id
    if not id then
        return { status = 400, json = { error = "ID url parameter not passed" } }
    end

    local success = pcall(models.Brands:delete(id))
    if not success then
        return { status = 500, json = { error = "Failed to delete brand" } }
    end

    return { status = 204 }
end

function resolvers.get_bubblegum_plural(ctx)
    applyDefaultHeaders(ctx)
    local pagination = parse_pagination(ctx)

    local success, gum = pcall(models.Bubblegum:select("LIMIT ? OFFSET ?", pagination.limit, pagination.offset))
    if not gum or not success then
        return { status = 500, json = { error = "Failed to fetch bubblegum" } }
    end

    return { json = gum }
end

function resolvers.get_bubblegum(ctx)
    applyDefaultHeaders(ctx)

    local id = ctx.params.id
    if not id then
        return resolvers.get_bubblegum_plural(ctx)
    end

    local success, gum = pcall(models.Bubblegum:find(id))
    if not gum or not success then
        return { status = 404, json = { error = "Bubblegum not found" } }
    end

    return { json = gum }
end

function resolvers.post_bubblegum(ctx)
    applyDefaultHeaders(ctx)

    local body = ctx.body
    if not body
    or not body.name
    or not body.flavor
    or not body.brand_id then
        return { status = 400, json = { error = "Invalid input, 'name', 'flavor', and 'brand_id' are required" } }
    end

    local success1, _ = pcall(models.Brands:find(body.brand_id))
    if not success1 then
        return { status = 500, json = { error = "Failed to find referenced brand" } }
    end

    local success2, gum = pcall(models.Bubblegum:create({
        name = body.name,
        flavor = body.flavor,
        brand_id = body.brand_id,
        price = body.price
    }))

    if not gum or not success2 then
        return { status = 500, json = { error = "Failed to create bubblegum" } }
    end

    return { status = 201, json = gum }
end

function resolvers.update_bubblegum(ctx)
    applyDefaultHeaders(ctx)

    local id = ctx.params.id
    local body = ctx.body
    if not id and (not body or not body.id)  then
        return { status = 400, json = { error = "Invalid input, ID is required" } }
    end

    local success, gum = pcall(models.Bubblegum:find(id))
    if not gum or not success then
        return { status = 500, json = { error = "Failed to find bubblegum" } }
    end
    
    local success2 = pcall(gum:update(body))
    if not success2 then
        return { status = 500, json = { error = "Failed to update bubblegum" } }
    end

    return { json = gum }
end

function resolvers.delete_bubblegum(ctx)
    applyDefaultHeaders(ctx)

    local id = ctx.params.id
    if not id then
        return { status = 400, json = { error = "ID url parameter not passed" } }
    end

    local success = pcall(models.Bubblegum:delete(id))
    if not success then
        return { status = 500, json = { error = "Failed to delete bubblegum" } }
    end

    return { status = 204 }
end

function resolvers.health(ctx)
    applyDefaultHeaders(ctx)
    return { json = { status = "Good, thanks xd" } }
end

return resolvers
