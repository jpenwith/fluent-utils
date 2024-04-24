import Fluent
//import FluentKit
import Foundation

public protocol ModelWithTimestamps: Fluent.Model {
    var createdAt: Date? { get }
    var updatedAt: Date? { get }
}

public extension ModelWithTimestamps {
    func requireCreatedAt() throws -> Date {
        guard let createdAt = self.createdAt else {
            throw FluentError.missingField(name: "createdAt")
        }
        return createdAt
    }

    func requireUpdatedAt() throws -> Date {
        guard let updatedAt = self.updatedAt else {
            throw FluentError.missingField(name: "updatedAt")
        }
        return updatedAt
    }
}


public extension Model {
    static func find<Field>(_ value: Field.Value?, uniqueField: KeyPath<Self, Field>, on database: Database) async throws -> Self? where Field: QueryableProperty {
        guard let value else {
            return nil
        }

        return try await Self.query(on: database)
            .filter(uniqueField == value)
            .first()
    }
    
    static func exists<Field>(_ value: Field.Value?, uniqueField: KeyPath<Self, Field>, on database: Database) async throws -> Bool where Field: QueryableProperty {
        guard let value else {
            return false
        }

        return try await Self.query(on: database)
            .filter(uniqueField == value)
            .count() > 0
    }
}
