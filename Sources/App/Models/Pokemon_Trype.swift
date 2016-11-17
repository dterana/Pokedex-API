import Vapor
import Fluent

final class Pokemon_Type: Model {
    
    
    // MARK: - Properties
    var id: Node?
    var exists: Bool = false
    
    var pokemon_id: Node
    var type_id: Node
    
    // MARK: - Init
    //Attention - Postgresql field name are only full lowcase
    init(pokemon_id: Node, type_id: Node) {
        self.id = nil
        self.pokemon_id = pokemon_id
        self.type_id = type_id
    }
    
    
    // MARK: - NodeConvertible
    //Attention - Postgresql field name are only full lowcase
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        pokemon_id = try node.extract("pokemon_id")
        type_id = try node.extract("type_id")
    }
    
    
    //Attention - Postgresql field name are only full lowcase
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "pokemon_id": pokemon_id,
            "type_id": type_id
            ])
    }
    
    
    // MARK: - Preparation
    //Attention - Postgresql field name are only full lowcase
    static func prepare(_ database: Database) throws {
        try database.create("pokemons_types") { users in
            users.id()
            users.int("pokemon_id")
            users.int("type_id")
        }
        
        
        var sql = "ALTER TABLE pokemons_types ADD CONSTRAINT pokemonfk FOREIGN KEY (pokemon_id) REFERENCES pokemons(id) MATCH FULL;"
    
        try database.driver.raw(sql)
        
        sql = "ALTER TABLE pokemons_types ADD CONSTRAINT typefk FOREIGN KEY (type_id) REFERENCES types(id) MATCH FULL;"
        
        try database.driver.raw(sql)
    }
    
    
    static func revert(_ database: Database) throws {
        try database.delete("pokemons_types")
    }
}
