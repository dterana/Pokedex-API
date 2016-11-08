import Vapor
import VaporPostgreSQL


let drop = Droplet(
    preparations: [Pokemon.self],
    providers: [VaporPostgreSQL.Provider.self]
    
)


drop.get("id", String.self) { request, pokemonId in
    return try JSON(node: [
        "index": "\(pokemonId)",
        "name": "Pikachu"
    ])
}

drop.run()
