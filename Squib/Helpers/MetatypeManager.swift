//
//  MetatypeManager.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


public class MetatypeManager {
    public static var stringBindableTypes: [Any.Type] = [
        String.self, Optional<String>.self,
        Date.self, Optional<Date>.self,
    ]
    
    public static var int64BindableTypes: [Any.Type] = [
        Int64.self, Optional<Int64>.self,
        Int.self, Optional<Int>.self,
        Bool.self, Optional<Bool>.self,
    ]
    
    public static var doubleBindableTypes: [Any.Type] = [
        Double.self, Optional<Double>.self,
    ]
    
    public static var blobBindableTypes: [Any.Type] = [
        Data.self, Optional<Data>.self,
    ]
}
