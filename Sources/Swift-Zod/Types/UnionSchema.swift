import Foundation

/// A schema that validates a value against multiple alternative schemas
/// and succeeds if **any one** of them passes.
///
/// Think of it as a logical **“OR”** between schemas.
///
/// Example:
/// ```swift
/// let idSchema = Z.union([
///     Z.string().uuid(),
///     Z.number().positive()
/// ])
///
/// try idSchema.parse("b8d3c9a2-8f63-4f02-9955-8ed42c2b1a47") // ✅
/// try idSchema.parse(42)                                     // ✅
/// try idSchema.parse(false)                                  // ❌
/// ```
public final class UnionSchema<Output>: Schema<Output> {
    private let options: [AnyValidator]

    /// Initializes a union schema with multiple alternative validators.
    ///
    /// - Parameter options: An array of schemas to try in order.
    public init(_ options: [any Validator]) {
        precondition(!options.isEmpty, "[UnionSchemaError] Union must have at least one schema.")
        self.options = options.map { AnyValidator($0) }
        super.init()
    }

    override public func parse(_ value: Any) throws -> Output {
        var collectedErrors: [String] = []

        for option in options {
            switch option.safeParse(value) {
            case let .success(parsedValue):
                if let casted = parsedValue as? Output {
                    return casted
                }
            case let .failure(error):
                collectedErrors.append(error.message)
            }
        }

        throw ValidationError(
            "[UnionSchemaError] Value did not match any union type: \(collectedErrors.joined(separator: ", "))"
        )
    }
}
