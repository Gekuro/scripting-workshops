local config = require "lapis.config"

config("development", {
    postgres = {
        host = os.getenv("POSTGRES_HOST") or "127.0.0.1",
        user = os.getenv("POSTGRES_USER") or "postgres",
        port = tonumber(os.getenv("POSTGRES_PORT") or "5432"),
        password = os.getenv("POSTGRES_PASSWORD") or "zaq1@WSX",
        database = os.getenv("POSTGRES_DB") or "bubble-pop-dev"
    }
})
