local Model = require("lapis.db.model").Model
local models = {}

models.Bubblegum = Model:extend("bubblegum")
models.Brands = Model:extend("brands")

return models