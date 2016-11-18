import Vapor
import HTTP
import VaporPostgreSQL

final class APIController {

  func addRoutes(drop: Droplet) {
    let apiV0 = drop.grouped("api/v0")

    apiV0.get("all", handler: all)
    apiV0.get(":filter", ":value", handler: specific)
  }

  func  all(request: Request) throws -> ResponseRepresentable {
    return try JSON(node: Pokemon.all().makeNode())
  }

  func specific(request: Request) throws -> ResponseRepresentable {

        let filter = try request.parameters.extract("filter") as String
        let value = try request.parameters.extract("value") as String

        //    Search can be by index, name, ...
        let filters = ["index", "name"]

        let current_filter = filter.lowercased()
        var current_value = value

        if !filters.contains(current_filter)  {
            throw Abort.badRequest
        }


        switch current_filter {

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


}
