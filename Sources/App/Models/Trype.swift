import Vapor
import Fluent

final class Type: Model {
    
    var id: Node?
    var exists: Bool = false
    
    var name: String
    
    //Attention - Postgresql field name are only full lowcase
    init(name: String) {
        self.id = nil
        self.name = name
    }
    
    
    //Attention - Postgresql field name are only full lowcase
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }
    
    
    //Attention - Postgresql field name are only full lowcase
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
            ])
    }
    
    //Attention - Postgresql field name are only full lowcase
    static func prepare(_ database: Database) throws {
        try database.create("types") { users in
            users.id()
            users.string("name")
        }
    }
    
    
    static func revert(_ database: Database) throws {
        try database.delete("types")
    }
}


extension Type {
    func types() throws -> Siblings<Pokemon> {
        return try siblings()
    }
}

