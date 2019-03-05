//
//  FileOP.swift
//  sst-ios-po
//
//  Created by Zal Zhang on 12/27/16.
//  Copyright © 2016 po. All rights reserved.
//

import UIKit

class FileOP: NSObject {
    
    static let fileManager = FileManager.default
    
    static func getFilePath(_ fileName: String) -> String? {
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if paths.count > 0 {
            return "\(paths[0])/"+fileName
        }
        return nil
    }
    
    static func fileExists(_ fileName: String) -> Bool {
        if let filePath = getFilePath(fileName) {
            return fileManager.fileExists(atPath: filePath)
        }
        return false
    }
    
    static func read(fileName: String, inBundle: Bool) -> AnyObject? {
        var physicalFlePath: String?
        if inBundle {
            physicalFlePath = Bundle.main.path(forResource: fileName, ofType: nil)
        } else {
            physicalFlePath = getFilePath(fileName)
        }
        if physicalFlePath != nil && fileManager.fileExists(atPath: validString(physicalFlePath)) {
            return fileManager.contents(atPath: physicalFlePath!) as AnyObject?
        }
        
        return nil
    }
    
    static func readJson(fileName: String, inBundle: Bool = true) -> Dictionary<String, Any>? {
        let data = read(fileName: fileName, inBundle: inBundle)
        if (data != nil) {
            let jsonObject = try? JSONSerialization.jsonObject(with: data as! Data, options:JSONSerialization.ReadingOptions.allowFragments)
            return jsonObject as? Dictionary<String, Any>
        }
        
        return nil
    }
    
    static func write(fileName: String, fileData: NSData, overwrite: Bool) -> Bool {
        if let physicalFlePath = getFilePath(fileName) {
            if overwrite || !fileManager.fileExists(atPath: physicalFlePath) {
                let data = NSMutableData()
                data.append(fileData as Data)
                data.write(toFile: physicalFlePath, atomically: true)
                return true
            }
        }
        
        return false
    }
    
    @discardableResult
    static func archive(_ fileName: String, object: Any) -> Bool {
        if let filePath = getFilePath(fileName) {
            return NSKeyedArchiver.archiveRootObject(object, toFile: filePath)
        }
        return false
    }
    
    static func unarchive(_ fileName: String) -> AnyObject? {
        if let filePath = getFilePath(fileName) {
            if fileExists(fileName) {
                return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as AnyObject?
            }
        }
        return nil
    }
    
    static func fileSize(path: String) -> Double {
        if fileManager.fileExists(atPath: path) {
            if let dict = try? fileManager.attributesOfItem(atPath: path) {
                if let fileSize = dict[FileAttributeKey.size] as? Int {
                    return Double(fileSize) / 1024.0 / 1024.0
                }
            }
        }
        return 0.0
    }
    
    static func folderSize(path: String) -> Double {
        var folderSize = 0.0
        if fileManager.fileExists(atPath: path) {
            if let childFiles = fileManager.subpaths(atPath: path) {
                for fileName in childFiles {
                    let tmpPath = path as NSString
                    let fileFullPathName = tmpPath.appendingPathComponent(fileName)
                    folderSize += FileOP.fileSize(path: fileFullPathName)
                }
                return folderSize
            }
        }
        return 0
    }
    
    static func cleanFolder(path: String, complete:()->()) {
        if let childFiles = fileManager.subpaths(atPath: path) {
            for fileName in childFiles {
                if fileName == kUserFileName {
                    continue
                }
                let tmpPath  = path as NSString
                let fileFullPathName = tmpPath.appendingPathComponent(fileName)
                if fileManager.fileExists(atPath: fileFullPathName) {
                    do {
                        try fileManager.removeItem(atPath: fileFullPathName)
                    } catch _ {
                        
                    }
                }
            }
        }
        complete()
    }

}
