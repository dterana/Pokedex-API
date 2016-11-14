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
            "weight": specificPokemon.weight
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
            ])
    }
}

drop.get("api/v0", "all") { request in
    return try JSON(node: Pokemon.all().makeNode())
}


drop.put("populate") { request in
    
    guard let specificPokemon = try Pokemon.query().filter("index", "001").first()  else {
        var pokemon: Pokemon
        
        pokemon = Pokemon(index: "001", name: "Bulbasaur", type: "Poison/Grass", basedefense: 49, baseattack: 49, height: 7, weight: 69, evolvl: 16, evoindex: "002")
        try pokemon.save()
        
        pokemon = Pokemon(index: "002", name: "Ivysaur", type: "Poison/Grass", basedefense: 63, baseattack: 62, height: 10, weight: 130,  evolvl: 32, evoindex: "003")
        try pokemon.save()
        
        pokemon = Pokemon(index: "003", name: "Venusaur", type: "Poison/Grass", basedefense: 83, baseattack: 82, height: 20, weight: 1000,  evolvl: -1, evoindex: "")
        try pokemon.save()
        
        return try JSON(node: Pokemon.all().makeNode())
    
    }

    return try JSON(node: Pokemon.all().makeNode())
}


drop.run()
