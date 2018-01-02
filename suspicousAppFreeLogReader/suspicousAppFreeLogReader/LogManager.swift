//
//  LogManager.swift
//  suspicousAppFreeLogReader
//
//  Created by Jacob Jiang on 01/01/2018.
//  Copyright © 2018 Jacob Jiang. All rights reserved.
//

import Foundation
import SSZipArchive

private let _shared = LogManager()

class LogManager {
    
    var result = ""
    var folderPath = ""

    class var shared: LogManager {
        return _shared
    }
    
    func unzipAllLogFiles() {
        guard FileManager.default.fileExists(atPath: folderPath) else {
            print("log folder doesn't existed")
            return
        }
        
        if let files = try? FileManager.default.contentsOfDirectory(atPath: folderPath) {
            print(files)
            for file in files {
                if file.hasSuffix(".zip") {
                    let unzipFile = "\(folderPath)\(file)"
                    let unzipDestFilePath = folderPath
                    print("unzip file:\(unzipFile) to \(unzipDestFilePath)")
                    let result = SSZipArchive.unzipFile(atPath: unzipFile, toDestination:unzipDestFilePath)
                    print("result:\(result)")
                }
            }
        }
    }
    
    func readLogFiles() {
        if let files = try? FileManager.default.contentsOfDirectory(atPath: folderPath) {
            let logFiles = files.filter {
                return $0.hasSuffix(".log")
            }
            print(logFiles)
            for file in logFiles {
                analyseLogFile(folderPath + file)
            }
        }
        
    }
    
    func analyseLogFile(_ path:String) {
        if let logString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
            let newLogArray = logString.components(separatedBy: "\n")
            let logArray = newLogArray.filter {
                return $0.hasPrefix("201")
            }
            
            result.append(path)
            result.append("\n")

            var i = 1
            var previewDate = logArray.first!.extractDate().convert2Date()
            
            while i < logArray.count {
                let lineI = logArray[i]
                let iDate = lineI.extractDate().convert2Date()
                let diff = iDate.timeIntervalSince(previewDate)
                print(diff)
                if diff > 5 {
                    result.append(logArray[i-1])
                    result.append("\n")
                    result.append(logArray[i])
                    result.append("\n")
                    result.append("\n")
                    result.append("\n")
                }
                previewDate = iDate
                i += 1
                
            }
            
        }
        
    }
    
    
}

extension String {
    
    func extractDate() -> String {
        let str = self[String.Index(encodedOffset: 0)...String.Index.init(encodedOffset: 18)]
        return String(str)
    }
    
    func convert2Date() -> Date {
        //2017-12-30 12:51:54,351 PST
        //2017-12-31 16:16:12,435 PST"
        let formatter = DateFormatter()
        formatter.isLenient = true
        formatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        let date = formatter.date(from: self)
        return date!
    }
}
