//
//  FrameworkInfoPlist.swift
//  QuickLookFramework
//
//  Created by Mario on 08/09/2019.
//  Copyright © 2019 Mario Iannotta. All rights reserved.
//

import Foundation

struct FrameworkInfoPlist: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case bundleName = "CFBundleName"
        case bundleIdentifier = "CFBundleIdentifier"
        case bundleVersionNumber = "CFBundleShortVersionString"
        case bundleBuildNumber = "CFBundleVersion"
        case platform = "DTPlatformName"
        case deviceFamilies = "UIDeviceFamily"
        case sdkVersion = "DTSDKName"
        case xcodeVersion = "DTXcode"
        case minimumOSVersion = "MinimumOSVersion"
    }
    
    enum DeviceFamily: Int, Decodable {
        case iPhone = 1
        case iPad = 2
        case tv = 3
        case watch = 4
        
        var name: String {
            switch self {
            case .iPhone:
                return "iPhone"
            case .iPad:
                return "iPad"
            case .tv:
                return "Apple TV"
            case .watch:
                return "Apple Watch"
            }
        }
    }
    
    let bundleName: String?
    let bundleIdentifier: String?
    private let bundleVersionNumber: String?
    private let bundleBuildNumber: String?
    let platform: String?
    private let deviceFamilies: [DeviceFamily]?
    let sdkVersion: String?
    let xcodeVersion: String?
    let minimumOSVersion: String?
    
    var bundleVersion: String? {
        return [bundleVersionNumber, bundleBuildNumber]
            .compactMap { $0 }
            .joined(separator: " - Build ")
    }
    var deviceFamiliesDescription: String? {
        return deviceFamilies?
            .compactMap { $0.name }
            .joined(separator: ", ")
    }
    
    init?(plistURL: URL) {
        guard
            let data = try? Data(contentsOf: plistURL)
            else {
                return nil
            }
        let plistDecoder = PropertyListDecoder()
        do {
            self = try plistDecoder.decode(FrameworkInfoPlist.self, from: data)
        } catch let error {
            print(error)
            return nil
        }
    }
    
}
