import Vapor
import HTTP

final class PostController: ResourceRepresentable {

    /// 返回的是所有user列表的json数据
    func index(req: Request) throws -> ResponseRepresentable {
        return try Post.all().makeJSON()
    }

    /// 创建并保存
    func create(request: Request) throws -> ResponseRepresentable {
        let post = try request.post()
        try post.save()
        return post
    }
    
 
    


    /// '/posts/13rd88' 返回一个指定user的json数据
    func show(req: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }

    func delete(req: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        return Response(status: .ok)
    }

    func clear(req: Request) throws -> ResponseRepresentable {
        try Post.makeQuery().delete()
        return Response(status: .ok)
    }

    func update(req: Request, post: Post) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try post.update(for: req)

        // Save an return the updated post.
        try post.save()
        return post
    }

    func replace(req: Request, post: Post) throws -> ResponseRepresentable {
 
        let new = try req.post()
        post.content = new.content
        try post.save()

        return post
    }

    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {

    func post() throws -> Post {
        guard let json = json else { throw Abort.badRequest }
        return try Post(json: json)
    }
}

extension PostController: EmptyInitializable { }
