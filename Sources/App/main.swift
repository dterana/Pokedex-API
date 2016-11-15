import Vapor
import VaporPostgreSQL


let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Pokemon.self


drop.get("api/v0", String.self, String.self) { request, filter, value in
    
    //    Search can be by index, name, ...
    guard let specificPokemon = try Pokemon.query().filter("\(filter)", value).first()  else {
        throw Abort.badRequest
    }
    
    if (specificPokemon.evoLvl) < 0 {
        
        return try JSON(node: [
            "index": "\(specificPokemon.index)",
            "name": "\(specificPokemon.name)",
            "type": "\(specificPokemon.type)",
            "basedefense": specificPokemon.baseDefense,
            "baseattack": specificPokemon.baseAttack,
            "height": specificPokemon.height,
            "weight": specificPokemon.weight,
            "description": specificPokemon.description
            ])
        
    } else {
        
        return try JSON(node: [
            "index": "\(specificPokemon.index)",
            "name": "\(specificPokemon.name)",
            "type": "\(specificPokemon.type)",
            "basedefense": specificPokemon.baseDefense,
            "baseattack": specificPokemon.baseAttack,
            "height": specificPokemon.height,
            "weight": specificPokemon.weight,
            "evolvl": specificPokemon.evoLvl,
            "evoindex": "\(specificPokemon.evoIndex)",
            "description": "\(specificPokemon.description)"
            ])
    }
}

drop.get("api/v0", "all") { request in
    return try JSON(node: Pokemon.all().makeNode())
}

drop.run()
