import Vapor
import Node // :EDIT:ADD:

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        /// GET /
        builder.get { req in
            return try self.view.make("welcome")
        }
        
        /// GET /hello/...
        builder.resource("hello", HelloController(view))
        
        // Template0: Basic HTML
        // http://localhost:8080/template0
        builder.get("template0") { 
            (req: Request) -> ResponseRepresentable in
            return try self.view.make("hello0") // hello0.leaf
        }
        
        // Template1: #(variable)
        // http://localhost:8080/template1
        // Node wrapper around dictionary for type safety
        builder.get("template1") { 
            (req: Request) -> ResponseRepresentable in
            return try self.view.make("hello1", Node(node: ["name": "Ray"]))
        }
        
        // Template2: URL /parameter
        // http://localhost:8080/template2/Roger 
        // http://localhost:8080/template2/27 
        builder.get("template2", String.parameter) { 
            (req: Request) -> ResponseRepresentable in
            do {
                let name = try req.parameters.next(String.self) // type safe
                return try self.view.make("hello1", Node(node: ["name": name]))
            }
            catch {
                return try JSON(node: ["error": "template 2 failed"])   
            }
        }
        
        // Template3a: #loop
        // http://localhost:8080/template3a
        builder.get("template3a") { 
            (req: Request) -> ResponseRepresentable in
            do {
                let users = try ["Ray", "Vicki", "Brian"].makeNode(in: nil)
                print("users=\(users)")
                let context = try Node(node: ["users": users])
                print("context=\(context)")
                return try self.view.make("hello2a", context)
            }
            catch let error {
                print("error=\(error.localizedDescription)")
                return try JSON(node: [
                    "msg": "template 3a failed", 
                    "err": error.localizedDescription]
                )   
            }
        }
        
        // Template3b: #loop, #(variable.field)
        // http://localhost:8080/template3b
        builder.get("template3b") { 
            (req: Request) -> ResponseRepresentable in
            do {
                let users = try [
                    ["name":"Ray", "email": "ray@razeware.com"].makeNode(in: nil),
                    ["name":"Vicki", "email": "vicki@razeware.com"].makeNode(in: nil),
                    ["name":"Brian", "email": "brian@razeware.com"].makeNode(in: nil)
                    ].makeNode(in: nil)
                return try self.view.make("hello2b", Node(node: ["users": users]))
            }
            catch {
                return try JSON(node: ["error": "template 3b failed"])   
            }
        }
        
        // Template4a: template #embed
        // http://localhost:8080/template4a
        builder.get("template4a") { 
            (req: Request) -> ResponseRepresentable in
            do {
                let users = try [
                    ["name":"Ray", "email": "ray@razeware.com"].makeNode(in: nil),
                    ["name":"Vicki", "email": "vicki@razeware.com"].makeNode(in: nil),
                    ["name":"Brian", "email": "brian@razeware.com"].makeNode(in: nil)
                    ].makeNode(in: nil)
                return try self.view.make("hello3a", Node(node: ["users": users]))
            }
            catch {
                return try JSON(node: ["error": "template 4a failed"])   
            }
        }
        
        // Template4b: template #extend, #export
        // http://localhost:8080/template4b
        builder.get("template4b") { 
            (req: Request) -> ResponseRepresentable in
            do {
                let users = try [
                    ["name":"Ray", "email": "ray@razeware.com"].makeNode(in: nil),
                    ["name":"Vicki", "email": "vicki@razeware.com"].makeNode(in: nil),
                    ["name":"Brian", "email": "brian@razeware.com"].makeNode(in: nil)
                    ].makeNode(in: nil)
                return try self.view.make("hello3b", Node(node: ["users": users]))
            }
            catch {
                return try JSON(node: ["error": "template 4b failed"])   
            }
        }

        // Template5a
        // http://localhost:8080/template5a?sayHello=true
        // http://localhost:8080/template5a?sayHello=false        
        builder.get("template5a") { 
            (req: Request) -> ResponseRepresentable in
            guard let sayHello = req.data["sayHello"]?.bool else {
                throw Abort.badRequest
            }
            return try self.view.make("hello4a", Node(node: ["sayHello": sayHello.makeNode(in: nil)]))
        }
        
        // Template5b 
        // http://localhost:8080/template5b?sayHello=true
        // http://localhost:8080/template5b?sayHello=false        
        builder.get("template5b") { 
            (req: Request) -> ResponseRepresentable in
            guard let sayHello = req.data["sayHello"]?.bool else {
                throw Abort.badRequest
            }
            return try self.view.make("hello4b", Node(node: ["sayHello": sayHello.makeNode(in: nil)]))
        }
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }
        
    }
}
