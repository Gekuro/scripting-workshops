local config = {
    postgres = {
        host = os.getenv("POSTGRES_HOST") or "127.0.0.1",
        port = tonumber(os.getenv("POSTGRES_PORT") or "5432"),
        user = os.getenv("POSTGRES_USER") or "postgres",
        password = os.getenv("POSTGRES_PASSWORD") or "zaq1@WSX",
        database = os.getenv("POSTGRES_DB") or "bubble-pop-dev"
    }
}

return config
