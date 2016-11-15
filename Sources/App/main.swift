import Vapor
import VaporPostgreSQL


let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Pokemon.self


drop.get("api/v0", String.self, String.self) { request, filter, value in
    
    //    Search can be by index, name, ...
    let filters = ["index", "name"]
    var current_value = value
    let current_filter = filter.lowercased()
    
    if !filters.contains(filter)  {
        throw Abort.badRequest
    }
    
    
    switch filter {
        
    // Treatment of the value to give it correct format if filter by index
    case "index":
        let tmp_value = Int(value)
        
        if tmp_value != nil {
            
            if tmp_value! < 10 {
                
                current_value = "00\(tmp_value!)"
                
            } else if tmp_value! < 100 {
                
                current_value = "0\(tmp_value!)"
                
            }
        }
        
        
    case "name":
        
        current_value = value.capitalized
        
    default:
        current_value = value
        
    }
    
        
        
    guard let specificPokemon = try Pokemon.query().filter("\(filter)", current_value).first()  else {
        throw Abort.badRequest
    }
    
    
    //if pokemon can't evolve
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
        
    //if pokemon can evolve
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
