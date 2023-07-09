//
//  Rebuildable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation
import Runtime


// MARK: - BasicallyRebuildable
public protocol BasicallyRebuildable {
    static func from(_ values: any Sequence<((any Storable)?, String?)>, _ stencil: Self?) throws -> Self
}


extension BasicallyRebuildable {
    public static func from<Sequence1: Sequence<(any Storable)?>, Sequence2: Sequence<String?>>(_ values: Sequence1, _ columns: Sequence2, _ stencil: Self? = nil) throws -> Self {
        return try from(zip(values, columns), stencil)
    }
    
    public static func from<Sequence1: Sequence<(any Storable)?>, Sequence2: Sequence<Address.Column>>(_ values: Sequence1, _ columns: Sequence2, _ stencil: Self? = nil) throws -> Self {
        return try from(zip(values, columns.map{$0.name}), stencil)
    }
}


extension Sequence where Element: BasicallyRebuildable {
    public static func from(_ values: any Sequence<any Sequence<((any Storable)?, String?)>>, _ stencil: Self.Element? = nil) throws -> Array<Element> {
        return try values.map {try Element.from($0, stencil)}
    }
    
    public static func from<Sequence1: Sequence<(any Storable)?>, Sequence2: Sequence<String?>>(_ values: some Sequence<Sequence1>, _ columns: Sequence2, _ stencil: Self.Element? = nil) throws -> Array<Element> {
        return try values.map{ try Element.from($0, columns, stencil) }
    }
    
    public static func from<Sequence1: Sequence<(any Storable)?>, Sequence2: Sequence<Address.Column>>(_ values: some Sequence<Sequence1>, _ columns: Sequence2, _ stencil: Self.Element? = nil) throws -> Array<Element> {
        return try values.map{ try Element.from($0, columns.map{$0.name}, stencil) }
    }
}


// MARK: - Rebuildable
public protocol Rebuildable: BasicallyRebuildable, Phantom {}


extension Rebuildable {
    public static func from(_ values: any Sequence<((any Storable)?, String?)>, _ stencil: Self? = nil) throws -> Self {
        var building: Self
        if stencil != nil {
            building = stencil!
        } else {
            building = Self.init()
        }
        
        let propertyInfos = Storehouse.shared.getItem(Self.self, "Rebuildable-from-propertyInfos") {
            return (try! typeInfo(of: Self.self)).properties.filter {$0.type is any ColumnableBridge.Type}
        }
        
        for propertyInfo in propertyInfos {
            if var property = try? propertyInfo.get(from: building) as? (any ColumnableBridge), let proton = values.first(where: {$0.1 == property.name}) {
                property.value = try type(of: property.value).from(proton.0)
                try? propertyInfo.set(value: property, on: &building)
            }
        }
        
        return building
    }
}
