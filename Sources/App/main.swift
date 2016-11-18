import Vapor
import VaporPostgreSQL
import Fluent


let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Pokemon.self
drop.preparations += Type.self
drop.preparations += Pokemon_Type.self

let api = APIController()
api.addRoutes(drop: drop)

drop.run()
