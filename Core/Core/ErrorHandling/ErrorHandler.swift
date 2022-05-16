//
//  ErrorHandler.swift
//  Core
//
//  Created by Shotiko Klibadze on 29.04.22.
//

import Foundation

public protocol ErrorReciever {
    func handleError(error: DBError)
}

public class ErrorHandler {
    
    static public let shared = ErrorHandler()
    private var errorReciever : ErrorReciever?
    
    public init() {}
    
    public func injectErrorReciever(errorReciever: ErrorReciever) {
        self.errorReciever = errorReciever
    }
    
    public func handleError(error: DBError) {
        errorReciever?.handleError(error: error)
    }
    
}
