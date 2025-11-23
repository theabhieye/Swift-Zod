//
//  ArraySchema.swift
//  SwiftZod
//
//  Created by Abhishek Kapoor on 09/11/25.
//

import Foundation

/// A schema responsible for validating arrays (lists of values).
///
/// `ArraySchema` validates both the structure (array) and each element
/// using a provided sub-schema.
///
/// Example:
/// ```swift
/// let stringArray = Z.array(Z.string())
/// try stringArray.parse(["A", "B", "C"]) // ✅
/// try stringArray.parse([1, 2, 3])       // ❌
/// ```
///
/// You can also chain constraints:
/// ```swift
/// let tags = Z.array(Z.string()).min(1).max(5)
/// try tags.parse(["Swift", "Zod"]) // ✅
/// ```
public final class ArraySchema<ElementSchema: Validator>: Schema<[ElementSchema.Output]> {
    // MARK: - Configuration

    private let elementSchema: ElementSchema
    private var minLength: Int?
    private var maxLength: Int?

    // MARK: - Initializer

    /// Creates a new array schema that validates elements using a given sub-schema.
    /// - Parameter elementSchema: The schema that each element must satisfy.
    public init(_ elementSchema: ElementSchema) {
        self.elementSchema = elementSchema
        super.init()
    }

    // MARK: - Builder Modifiers

    /// Sets the minimum number of elements required.
    @discardableResult
    public func min(_ count: Int) -> Self {
        precondition(count >= 0, "Minimum array length must be non-negative.")
        minLength = count
        return self
    }

    /// Sets the maximum number of elements allowed.
    @discardableResult
    public func max(_ count: Int) -> Self {
        precondition(count >= 0, "Maximum array length must be non-negative.")
        maxLength = count
        return self
    }

    // MARK: - Validation Logic

    override public func parse(_ value: Any) throws -> [ElementSchema.Output] {
        // Ensure it’s an array
        guard let array = value as? [Any] else {
            throw ValidationError("Expected array, got \(type(of: value))")
        }

        // Length checks
        if let min = minLength, array.count < min {
            throw ValidationError("[ArraySchemaError] Expected at least \(min) elements but got \(array.count).")
        }
        if let max = maxLength, array.count > max {
            throw ValidationError("[ArraySchemaError] Expected at most \(max) elements but got \(array.count).")
        }

        // Validate each element
        var validated: [ElementSchema.Output] = []
        for (index, item) in array.enumerated() {
            do {
                let parsed = try elementSchema.parse(item)
                validated.append(parsed)
            } catch let err as ValidationError {
                // Tag the error with index info for debugging
                throw ValidationError(
                    "[ArraySchemaError] Element at index \(index) failed validation: \(err.message)",
                    path: err.path + ["[\(index)]"]
                )
            } catch {
                throw ValidationError("[ArraySchemaError] Unknown validation error at index \(index).")
            }
        }

        return validated
    }
}
