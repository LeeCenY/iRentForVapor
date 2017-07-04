import Vapor
import FluentProvider
import HTTP

final class Post: Model {
    let storage = Storage()
    
    // MARK: 属性和数据库键
    
    /// post内容
    var content: String
    
    /// 数据库中id 和内容的列表名
    static let idKey = "id"
    static let contentKey = "content"

    /// 创建新的post
    init(content: String) {
        self.content = content
    }

    // MARK: 初始化

    /// 初始化 post
    /// database row
    init(row: Row) throws {
        content = try row.get(Post.contentKey)
    }

    // 将posth初始化到数据库
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Post.contentKey, content)
        return row
    }
}

// MARK: Fluent 准备

extension Post: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Post.contentKey)
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Post (POST /posts)
//     - Fetching a post (GET /posts, GET /posts/:id)
//
extension Post: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            content: json.get(Post.contentKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Post.idKey, id)
        try json.set(Post.contentKey, content)
        return json
    }
}

// MARK: HTTP

// 返回post模型
// directly in route closures
extension Post: ResponseRepresentable { }

// MARK: Update

// 这样可以更新Post模型
// 根据请求动态
extension Post: Updateable {
   
    public static var updateableKeys: [UpdateableKey<Post>] {
        return [

            UpdateableKey(Post.contentKey, String.self) { post, content in
                post.content = content
            }
        ]
    }
}
