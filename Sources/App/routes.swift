import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { request in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { request in
        return "Hello, world!"
    }
    
    router.get("testmodel") { request -> Future<[TestModel]> in
        let models = TestModel.query(on: request).all()
        return models
    }

    router.get("testweb") { request -> Future<View> in
        return TestModel.query(on: request).all().flatMap { results in
            let data = ["testlist": results]
            return try request.view().render("testview", data)
        }
    }
    
    router.post("testweb") { request in
        return try request.content.decode(TestModel.self).flatMap { item in
            return item.save(on: request).map { _ in
                return request.redirect(to: "testweb")
            }
        }
    }
}
