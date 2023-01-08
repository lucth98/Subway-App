//
//  NetworkError.swift
//  Subway App
//
//  Created by Lucas on 08.01.23.
//

import Foundation

enum NetworkError: Error{
    case networkIsOfflineError(String)
    case responceDataFormatIsInFalseFormatError(String)
    case noSuccesfulResponseCodeError(String)
    case unknownError(String)
    case savingError(String)
}

