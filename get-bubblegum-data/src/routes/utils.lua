local utils = {}

local DEFAULT_PAGE_LIMIT = 20
local DEFAULT_PAGE_LIMIT_CAP = 120

function utils.apply_default_headers(ctx)
    ctx.res.headers["Content-Type"] = "application/json"
    ctx.res.headers["Server"] = "bubble-pop/" .. (os.getenv("APP_VERSION") or "unknown")
    ctx.res.headers["Cache-Control"] = "no-cache"
end

function utils.parse_pagination(ctx)
    local limit = DEFAULT_PAGE_LIMIT
    local page = 1
    
    if not ctx.params then
        return { limit = limit, offset = (page - 1) * limit }
    end

    if ctx.params.limit and tonumber(ctx.params.limit) then
        limit = tonumber(ctx.params.limit)
        if limit < 1 then
            limit = DEFAULT_PAGE_LIMIT
        elseif limit > DEFAULT_PAGE_LIMIT_CAP then
            limit = DEFAULT_PAGE_LIMIT_CAP
        end
    end

    if ctx.params.page and tonumber(ctx.params.page) then
        page = tonumber(ctx.params.page)
        if page < 1 then
            page = 1
        end
    end

    return { limit = limit, offset = (page - 1) * limit }
end

return utils