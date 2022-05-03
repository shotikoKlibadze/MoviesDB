//
//  DBError.swift
//  Core
//
//  Created by Shotiko Klibadze on 18.03.22.
//

import Foundation

public struct DBError : Error {
    
    public let errorMessage: String
    public let debugMessage: String?
    public let endPoint: String?
    
    public init(errorMessage: String, debugMessage: String?, endPoint: String?) {
        self.errorMessage = errorMessage
        self.debugMessage = debugMessage
        self.endPoint = endPoint
    }
    
}

extension DBError : CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            ❌ 
            Error Message: \(self.errorMessage)
            DebugMessage: \(self.debugMessage ?? "n/a")
            Path: \(self.endPoint ?? "n/a")
            ❌
            """
    }
}
