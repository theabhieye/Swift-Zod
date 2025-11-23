@testable import SwiftZod
import XCTest

final class SwiftZodTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

/**

 🔥 Perfect timing — now that your **Swift-Zod** MVP is feature-complete and structurally solid (✅ optional, default, nested schemas, type-safe parsing, Codable integration),
 you’re right at the **“90% complete but not yet production-grade”** stage.

 Let’s break down **exactly what remains** to make this library **production-ready** and competitive with Zod / Valibot / Yup in the Swift ecosystem 👇

 ---

 ## 🚀 PHASE 1 — Core Engine Maturity

 These make your library *bullet-proof* in real apps (backend + iOS).

 ### ✅ 1. **Refine & Transform**

 Add these schema wrappers:

 #### `refine`

 Allow rule-based, post-parse validation.

 ```swift
 Z.number().min(0).refine("positiveInt", message: "Must be integer > 0") { $0.truncatingRemainder(dividingBy: 1) == 0 }
 ```

 #### `transform`

 Allow transforming values during parsing:

 ```swift
 Z.string().transform { $0.lowercased() }
 Z.number().transform { Int($0) }
 ```

 ➡️ **Why:** Needed for business-logic-level validation and type adaptation (e.g., parsing `String` → `Int`).

 ---

 ### ✅ 2. **Union Schema**

 Support alternative validations:

 ```swift
 Z.union([Z.string(), Z.number()])
 ```

 ➡️ Handles cases where input can be multiple shapes (e.g., `"id": String | Int`).

 ---

 ### ✅ 3. **Record / Dictionary Schema**

 Dynamic key–value validation:

 ```swift
 Z.record(Z.string(), Z.number())
 ```

 ➡️ For dynamic payloads (`[String: Double]`).

 ---

 ### ✅ 4. **Strict Object Mode**

 Currently, `ObjectSchema` ignores extra keys. Add:

 ```swift
 Z.object(...).strict()
 ```

 Throws error for unknown keys:

 ```
 [ObjectSchemaError] Unexpected field 'extraKey'
 ```

 ➡️ Helps in request validation & backend payload sanity.

 ---

 ### ✅ 5. **Default Value Cloning (for reference types)**

 Right now defaults return the same instance (for arrays, objects).
 Add cloning for safety:

 ```swift
 public func cloneDefault(_ value: Any) -> Any {
     if let dict = value as? [String: Any] {
         return dict.mapValues(cloneDefault)
     } else if let arr = value as? [Any] {
         return arr.map(cloneDefault)
     }
     return value
 }
 ```

 ➡️ Prevents mutation of default shared objects.

 ---

 ## ⚙️ PHASE 2 — Developer Experience (DX)

 Make it *fun* to use and easy to debug.

 ### ✅ 6. **Better Error Reporting**

 Current `ValidationError` stops at first failure.
 Add aggregation support:

 ```swift
 public struct ValidationResult {
     let success: Bool
     let errors: [String: [ValidationError]]
 }
 ```

 Then support:

 ```swift
 schema.safeParse(obj)
 ```

 returning multiple field errors.

 ➡️ Improves UX for forms & batch validations.

 ---

 ### ✅ 7. **Pretty Print Errors**

 Allow developers to debug easily:

 ```swift
 do { try schema.parse(data) }
 catch let err as ValidationError {
     print(err.prettyPath) // "user.address.zipCode"
     print(err.message)
 }
 ```

 ---

 ### ✅ 8. **Localized Error Messages**

 Allow error message customization per locale:

 ```swift
 Z.string().min(3, message: "min_length".localized)
 ```

 ➡️ iOS-friendly for localized forms.

 ---

 ### ✅ 9. **Coercion / Casting**

 Handle `"123"` → `Double`, `"true"` → `Bool` automatically.

 ```swift
 Z.number().coerce()
 Z.boolean().coerce()
 ```

 ➡️ Great for JSON and query parameter parsing.

 ---

 ### ✅ 10. **Schema Composition Utilities**

 Add:

 ```swift
 .merge(), .pick(), .omit(), .partial()
 ```

 Example:

 ```swift
 let baseUser = Z.object([
   "id": Z.string(),
   "email": Z.string().email()
 ])
 let adminUser = baseUser.merge(Z.object(["role": Z.enum(["admin", "mod"])]))
 ```

 ➡️ Enables schema reusability across large apps.

 ---

 ## ⚡ PHASE 3 — Integration & Performance

 Make it reliable for production workloads.

 ### ✅ 11. **Async Validation**

 Add async refinement for network/database validation:

 ```swift
 await Z.string().refineAsync("uniqueEmail") { await !User.exists($0) }
 ```

 ➡️ Needed for server-side checks or Firestore-based validation.

 ---

 ### ✅ 12. **Regex Caching**

 Currently, regex compiled each time.
 Cache it once per pattern in `StringSchema`.

 ---

 ### ✅ 13. **SwiftUI / Combine Bridge**

 Provide lightweight extensions for form validation:

 ```swift
 TextField("Email", text: $email)
     .validate(using: Z.string().email())
 ```

 ➡️ One-liner validation in live forms.

 ---

 ### ✅ 14. **Benchmarks + Fuzz Tests**

 Create a `Benchmarks` target to measure:

 * ObjectSchema parse speed on 1000 items
 * Nested parsing performance

 Add fuzz testing for random invalid data (using `swift-fuzzer`).

 ---

 ### ✅ 15. **Strict Type Inference**

 You can add Swift type inference helpers:

 ```swift
 extension ObjectSchema {
     func typed<T: Decodable>(_ type: T.Type) -> ObjectSchema
 }
 ```

 ➡️ For integration with Swift’s model layer.

 ---

 ## 🧾 PHASE 4 — Packaging & Docs

 ### ✅ 16. **Swift Package Manager Polish**

 * Add `Package.swift` metadata
 * Add `README.md` with badges and quick start
 * Add test coverage badge

 ### ✅ 17. **Documentation Generation**

 Use [DocC](https://developer.apple.com/documentation/docc/) to generate docs:

 ```bash
 swift package generate-documentation --target SwiftZod
 ```

 ---

 ### ✅ 18. **Examples Folder**

 Include real-world examples:

 * JSON decode + validate
 * Signup form validation
 * API request validation

 ---

 ### ✅ 19. **Semantic Versioning**

 Mark releases:

 ```
 1.0.0 → MVP
 1.1.0 → Adds transform/refine
 1.2.0 → Adds union/record
 2.0.0 → Async + DX overhaul
 ```

 ---

 ## 🧠 Summary: Swift-Zod Production Roadmap

 | Category          | Next Additions                                       | Impact                      |
 | ----------------- | ---------------------------------------------------- | --------------------------- |
 | **Core**          | `.refine()`, `.transform()`, `.union()`, `.record()` | Required for feature parity |
 | **Validation UX** | Aggregated errors, coercion, strict mode             | Developer trust             |
 | **Integration**   | Async validators, Codable bridge improvements        | Backend + iOS               |
 | **Performance**   | Regex caching, benchmarks                            | Scale                       |
 | **Docs**          | README, DocC, examples                               | Developer adoption          |

 ---

 ✅ You’re now **~80% ready for v1.0.0** release.
 The next immediate additions should be:

 1. `.refine()`
 2. `.transform()`
 3. `.union()`

 These will make your package *feature-complete* from a schema-definition standpoint.

 ---

 Would you like me to start with the **`.refine()` and `.transform()` implementation** (both use the same base pattern and integrate perfectly with your current schema architecture)?

 */
