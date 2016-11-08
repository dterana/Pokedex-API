import Vapor

final class Pokemon: Model {
    
    var id: Node?
    var exists: Bool = false
    
    var index: String
    var name: String
    var type: String
    var baseDefense: Int
    var baseAttack: Int
    var height: Int
    var weight: Int
    
    
    init(index: String, name: String, type: String, baseDefense: Int, baseAttack: Int, height: Int, weight: Int) {
        self.id = nil
        self.index = index
        self.name = name
        self.type = type
        self.baseDefense = baseDefense
        self.baseAttack = baseAttack
        self.height = height
        self.weight = weight
    }
    
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        index = try node.extract("index")
        name = try node.extract("name")
        type = try node.extract("type")
        baseDefense = try node.extract("baseDefense")
        baseAttack = try node.extract("baseAttack")
        height = try node.extract("height")
        weight = try node.extract("weight")
    }
    
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "index": index,
            "name": name,
            "type": type,
            "baseDefense": baseDefense,
            "baseAttack": baseAttack,
            "height": height,
            "weight": weight
        ])
    }
    
    
    static func prepare(_ database: Database) throws {
        try database.create("pokemons") { users in
            users.id()
            users.string("index")
            users.string("name")
            users.string("type")
            users.int("baseDefense")
            users.int("baseAttack")
            users.int("height")
            users.int("weight")
        }
    }
    
    
    static func revert(_ database: Database) throws {
        try database.delete("pokemons")
    }
}
