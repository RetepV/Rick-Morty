//
//  APIDefinitions.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//

enum APIError: Error {
    
    case noResponseFromServer
    case fetchingDataFailed(httpStatusCode: Int)
    
    case decodeJSONFailed(error: Error)
    
    case parameterError(info: String)
    case noDataFound(info: String?)
    
    case unexpectedResultError
    case requestError(code: String?, description: String?)
}

enum APIRecordState: Int16 {
    case placeHolder
    case upToDate
    case outDated
}
