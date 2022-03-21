//
//  DBError.swift
//  Core
//
//  Created by Shotiko Klibadze on 18.03.22.
//

import Foundation

public struct DBError : Error {
    
    public let errorMessage: String
    public let endPoint: String?
    
    public init(errorMessage: String, endPoint: String?) {
        self.errorMessage = errorMessage
        self.endPoint = endPoint
    }
    
}

extension DBError : CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            ❌ 
            Error Message: \(self.errorMessage)
            Endpoint: \(self.endPoint ?? "n/a")
            ❌
            """
    }
    
    
}
