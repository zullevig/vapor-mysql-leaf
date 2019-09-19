import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.post("testmodel") { req -> Future<Response> in
        return try req.content.decode(TestModel.self).flatMap { test in
            return test.save(on: req).map { _ in
                return req.redirect(to: "test")
            }
        }
    }
    
    router.get("testmodel") { req -> Future<View> in
        return TestModel.query(on: req).all().flatMap { results in
            let data = ["testlist": results]
            return try req.view().render("testview", data)
        }
    }
}