//
//  PreviewViewController.swift
//  QuickLookFramework
//
//  Created by Mario on 08/09/2019.
//  Copyright © 2019 Mario Iannotta. All rights reserved.
//

import Foundation
import Cocoa

public class PreviewViewController: NSViewController {
    
    // MARK: - Factory method
    
    @objc
    public static func show(url: NSURL, context: NSGraphicsContext) {
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle(for: self))
        guard
            let viewController = storyboard.instantiateInitialController() as? PreviewViewController
            else { return }
        viewController.url = url as URL
        viewController.view.displayIgnoringOpacity(viewController.view.frame, in: context)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleTextField: NSTextField!
    @IBOutlet private weak var bundleNameTextField: NSTextField!
    @IBOutlet private weak var bundleIdentifierTextField: NSTextField!
    @IBOutlet private weak var bundleVersionTextField: NSTextField!
    @IBOutlet private weak var architecturesTextField: NSTextField!
    @IBOutlet private weak var minimumOSVersionTextField: NSTextField!
    @IBOutlet private weak var supportedPlatformsTextField: NSTextField!
    @IBOutlet private weak var deviceFamilyTextField: NSTextField!
    @IBOutlet private weak var sdkTextField: NSTextField!
    @IBOutlet private weak var xcodeTextField: NSTextField!
    @IBOutlet private weak var sizeTextField: NSTextField!
    @IBOutlet private weak var createdDateTextField: NSTextField!
    @IBOutlet private weak var modifiedDateTextField: NSTextField!
    
    // MARK: - Private properties
    
    private var url: URL?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let frameworkURL = url,
            let frameworkName = frameworkURL
                .lastPathComponent
                .components(separatedBy: ".framework")
                .first
            else { return }
        
        let commandLineHandler = CommandLineHandler(path: frameworkURL.path)
        titleTextField.stringValue = frameworkURL.lastPathComponent
        sizeTextField.stringValue = commandLineHandler.fetchSize() ?? "-"
        createdDateTextField.stringValue = commandLineHandler.fetchCreationDate() ?? "-"
        modifiedDateTextField.stringValue = commandLineHandler.fetchModificationDate() ?? "-"
        
        fillPlistDrivenFields(frameworkURL: frameworkURL, commandLineHandler: commandLineHandler)
        
        architecturesTextField.stringValue = commandLineHandler
            .listArchitectures(frameworkName: frameworkName)
            .joined(separator: ", ")
    }
    
    private func fillPlistDrivenFields(frameworkURL: URL, commandLineHandler: CommandLineHandler) {
        guard
            let plist = commandLineHandler
            .findFile(named: "Info.plist")?
            .sorted(by: { $0.count < $1.count }) // let's assume that if we have mulitple Info.plist, the right one is the one nearest to the root
            .first
            .flatMap({ "\($0.dropFirst(2))" }) // remove the first two characters "./"
            .flatMap({ frameworkURL.appendingPathComponent($0) })
            .flatMap({ FrameworkInfoPlist(plistURL: $0) })
            else { return }
        bundleNameTextField.stringValue = plist.bundleName ?? "-"
        bundleIdentifierTextField.stringValue = plist.bundleIdentifier ?? "-"
        bundleVersionTextField.stringValue = plist.bundleVersion ?? "-"
        minimumOSVersionTextField.stringValue = plist.minimumOSVersion ?? "-"
        sdkTextField.stringValue = plist.sdkVersion ?? "-"
        xcodeTextField.stringValue = getPrettyXCodeVersion(rawXcodeVersion: plist.xcodeVersion ?? "") ?? "-"
        deviceFamilyTextField.stringValue = plist.deviceFamiliesDescription ?? "-"
        supportedPlatformsTextField.stringValue = plist.platform ?? "-"
    }
    
    private func getPrettyXCodeVersion(rawXcodeVersion: String) -> String? {
        guard
            rawXcodeVersion.count == 4
            else {
                return nil
            }
        let major = rawXcodeVersion[0..<2]
        let minor = rawXcodeVersion[2]
        let patch = rawXcodeVersion[3]
        return [major, minor, patch]
            .compactMap { value -> Int? in
                guard
                    let valueAsInt = Int(value),
                    valueAsInt > 0
                    else {
                        return nil
                    }
                return valueAsInt
            }
            .compactMap { String($0) }
            .joined(separator: ".")
    }
}

