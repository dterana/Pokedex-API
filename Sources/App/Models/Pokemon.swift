import Vapor

final class Pokemon: Model {
    
    var id: Node?
    var exists: Bool = false
    
    var index: String
    var name: String
    var type: String
    var baseDefense: String
    var baseAttack: String
    var height: String
    var weight: String
    var evoLvl: String
    var evoIndex: String
    
    //Attention - Postgresql field name are only full lowcase
    init(index: String, name: String, type: String, basedefense: String, baseattack: String, height: String, weight: String, evolvl: String, evoindex: String) {
        self.id = nil
        self.index = index
        self.name = name
        self.type = type
        self.baseDefense = basedefense
        self.baseAttack = baseattack
        self.height = height
        self.weight = weight
        self.evoLvl = evolvl
        self.evoIndex = evoindex
    }
    
    
    //Attention - Postgresql field name are only full lowcase
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        index = try node.extract("index")
        name = try node.extract("name")
        type = try node.extract("type")
        baseDefense = try node.extract("basedefense")
        baseAttack = try node.extract("baseattack")
        height = try node.extract("height")
        weight = try node.extract("weight")
        evoLvl = try node.extract("evolvl")
        evoIndex = try node.extract("evoindex")
    }
    
    
    //Attention - Postgresql field name are only full lowcase
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "index": index,
            "name": name,
            "type": type,
            "basedefense": baseDefense,
            "baseattack": baseAttack,
            "height": height,
            "weight": weight,
            "evolvl": evoLvl,
            "evoindex": evoIndex
        ])
    }
    
    //Attention - Postgresql field name are only full lowcase
    static func prepare(_ database: Database) throws {
        try database.create("pokemons") { users in
            users.id()
            users.string("index")
            users.string("name")
            users.string("type")
            users.string("basedefense")
            users.string("baseattack")
            users.string("height")
            users.string("weight")
            users.string("evolvl")
            users.string("evoindex")
        }
    }
    
    
    static func revert(_ database: Database) throws {
        try database.delete("pokemons")
    }
}
