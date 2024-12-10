local resolvers = {};

local function applyDefaultHeaders(ctx) 
    ctx.res.headers["Content-Type"] = "application/json"
    ctx.res.headers["Server"] = "bubble-pop/" .. (os.getenv("APP_VERSION") or "unknown")
    ctx.res.headers["Cache-Control"] = "no-cache"
end

function resolvers.health(ctx)
    applyDefaultHeaders(ctx)
    return { json = { status = "Good, thanks" } }
end

function resolvers.bubblegum_of_the_day(ctx)
    applyDefaultHeaders(ctx)
    return nil
end

return resolvers