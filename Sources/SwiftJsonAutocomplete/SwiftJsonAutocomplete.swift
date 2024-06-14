// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

public struct JSONAutocompleter {
    public static let shared = JSONAutocompleter()
    
    private let dataCloseChar: [Character: Character] = [
        "{": "}",
        "[": "]",
        "\"": "\""
    ]
    
    public func completeJSON(_ jsonString: String?) -> String? {
        guard var string = jsonString?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
        
        // Removing unwanted characters
        string = string
                    .replacingOccurrences(of: "\\s{2,}", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "(?<=:)([a-zA-Z]+)(?=\\s*(?![\\,\\}])(?:[\\,\\}\\s]|$))", with: "null", options: .regularExpression)
        
        var missingChars: [Character] = []
        
        for char in string {
            if let last = missingChars.last, char == last {
                missingChars.removeLast()
            } else if let closeChar = dataCloseChar[char] {
                missingChars.append(closeChar)
                if char == "{" {
                    missingChars.append(":")
                }
            }
        }
        
        if let last = missingChars.last, last == ":" {
            if string.last != "{" {
                // Instead of adding a string, we concatenate `: null`
                missingChars.removeLast()
                string += ": null"
            } else {
                missingChars.removeLast()
            }
        }
        
        let missingCharsString = String(missingChars.reversed())
        let completeString = string + missingCharsString
        
        let cleanedString = completeString
            .replacingOccurrences(of: "\"\":", with: "")
            .replacingOccurrences(of: "\":}|\": }", with: "\": null }", options: .regularExpression)
            .replacingOccurrences(of: ",\"\"}|,}|,\"\"]}", with: "}", options: .regularExpression)
            .replacingOccurrences(of: "},]", with: "}]", options: .regularExpression)
        
        return cleanedString
    }
}
