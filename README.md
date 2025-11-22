# Swift-Zod  
A super-fast, type-safe, composable validation library for Swift — inspired by Zod.

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)]()
![Platform](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS-blue.svg)
[![License](https://img.shields.io/badge/License-MIT-green.svg)]()
[![Build](https://github.com/theabhieye/Swift-Zod/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/theabhieye/Swift-Zod/actions/workflows/ci.yml)
[![Code Coverage](https://img.shields.io/badge/Coverage-80%25+-brightgreen.svg)]()

Swift-Zod is a modern validation library for Swift that makes it easy to **parse**, **validate**, and **refine** untyped data.  
It brings the declarative, composable API of JavaScript’s Zod into Swift — ideal for apps, backend services, JSON validation, and request parsing.

---

## 🚀 Features

- ✔ Schema-based parsing & validation  
- ✔ Type-safe `parse()` and `safeParse()`  
- ✔ String, Number, Boolean, Array, Enum, Optional schemas  
- ✔ Object validation with nested support  
- ✔ `.refine()` for custom validation rules  
- ✔ `.transform()` for output shaping  
- ✔ `.default()` and optional chaining  
- ✔ `.coerce.*` helpers (`String`, `Number`, `Boolean`)  
- ✔ Codable integration: `decodeAndValidate()`  
- ✔ 100% Swift, zero dependencies  
- ✔ Fully tested: >300 test cases  

---

## 📦 Installation (Swift Package Manager)

Add this to your project's `Package.swift`:

```swift
.dependencies: [
    .package(url: "https://github.com/abhishek-kapoor/SwiftZod.git", from: "1.0.0")
]
````

Then import it:

```swift
import SwiftZod
```

---

## 🧩 Quick Start

### Validate a simple object:

```swift
let UserSchema = Z.object([
    "id": Z.string().uuid(),
    "email": Z.string().email(),
    "age": Z.number().min(18),
    "isActive": Z.boolean()
])

let data: [String: Any] = [
    "id": "9e1c9832-1ff8-4d1f-9e72-c2a894bb3ab1",
    "email": "user@example.com",
    "age": 24,
    "isActive": true
]

let result = try UserSchema.parse(data)
```

---

## 🧪 Safe Parsing (No Exceptions)

```swift
switch UserSchema.safeParse(data) {
case .success(let user):
    print("Valid:", user)
case .failure(let error):
    print("Error:", error.message)
}
```

---

## 🪄 Coercion (String → Number → Bool)

```swift
let Schema = Z.object([
    "age": Z.coerce.number().min(18),
    "active": Z.coerce.boolean()
])

try Schema.parse([
    "age": "21",
    "active": "yes"
])
```

---

## 🧱 Refining & Transforming

```swift
let PasswordSchema = Z.string()
    .min(8)
    .refine("hasUppercase", message: "Must include uppercase") { $0.contains { $0.isUppercase } }
    .transform { $0.trimmingCharacters(in: .whitespaces) }
```

---

## 🧬 Codable + Swift-Zod

```swift
struct User: Codable {
    let id: String
    let email: String
    let age: Int
}

let schema = Z.object([
    "id": Z.string().uuid(),
    "email": Z.string().email(),
    "age": Z.number().min(18)
])

let user = try User.decodeAndValidate(from: jsonData, schema: schema)
```

---

## 📚 API Overview

### Schemas

* `Z.string()`
* `Z.number()`
* `Z.boolean()`
* `Z.array(T)`
* `Z.object([:])`
* `Z.enum([...])`
* `Z.optional()`
* `Z.union([...])`
* `Z.coerce.string()`
* `Z.coerce.number()`
* `Z.coerce.boolean()`

### Common Modifiers

| Modifier                 | Description                |
| ------------------------ | -------------------------- |
| `.min(n)`                | Min length / value         |
| `.max(n)`                | Max length / value         |
| `.refine(name, message)` | Custom validation          |
| `.transform(fn)`         | Map output                 |
| `.default(value)`        | Default value when missing |
| `.optional()`            | Makes field nullable       |
| `.email()`               | Email validation           |
| `.uuid()`                | UUID format                |
| `.url()`                 | URL validation             |
| `.phone()`               | Phone number format        |
| `.alphanumeric()`        | Alphanumeric string        |

---

## 🧱 Project Structure

```
Sources/
  Swift-Zod/
    Core/
    Types/
    Utils/
Tests/
  Swift-ZodTests/
```

---

## 🧪 Testing

Run all tests:

```bash
swift test --parallel
```

Generate coverage:

```bash
swift test --enable-code-coverage
```

---

## 🔧 Roadmap (v1 → v2)

### v1.0.0

* Core types
* Transform & Refine
* Union & Coercion
* Codable support
* 300+ tests

### v1.1.0

* Record schema
* Strict object mode

### v2.0.0

* Async validations
* Aggregated error sets
* Schema merging utilities
* Regex caching & performance improvements

---

## 🤝 Contributing

Pull requests are welcome!
Before submitting, ensure:

* Tests are updated
* Coverage ≥ 80%
* CI passes

---

## 📄 License

Licensed under the **MIT License**.
See [`LICENSE`](LICENSE) for details.

---

## 👤 Author & Community

**Abhishek Kapoor**

📧 Email: [abhikapoor2000.ak@gmail.com](mailto:abhikapoor2000.ak@gmail.com)
🔗 LinkedIn: [https://www.linkedin.com/in/abhishekkapoorfullstack/](https://www.linkedin.com/in/abhishekkapoorfullstack/)

---

## ⭐ Support

If you like this package, **star the repo** — it helps a lot!

