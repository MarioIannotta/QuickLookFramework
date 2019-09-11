//
//  CommandLineHandler.swift
//  QuickLookFramework
//
//  Created by Mario on 08/09/2019.
//  Copyright © 2019 Mario Iannotta. All rights reserved.
//

import Foundation

struct CommandLineHandler {
    
    private struct Commands {
        let findFile = "cd %@; find . -name %@"
        let listArchitectures = "cd %@; lipo -info %@"
        let fetchSize = "cd %@; du -hs"
        let fetchCreationDate = "cd %@; GetFileInfo -d ."
        let fetchModificationDate = "cd %@; GetFileInfo -m ."
    }
    
    init(path: String) {
        self.path = path
    }
    
    private let commands = Commands()
    private let path: String
    
    private func executeCommand(_ command: String) -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.droppingFinalCharacter ?? ""
    }
    
    func findFile(named fileName: String) -> [String]? {
        let findFile = String(format: commands.findFile, path, fileName)
        return executeCommand(findFile).components(separatedBy: .newlines)
    }
    
    func listArchitectures(frameworkName: String) -> [String] {
        let listArchitecturesCommand = String(format: commands.listArchitectures, path, frameworkName)
        return executeCommand(listArchitecturesCommand)
            .components(separatedBy: ": ")
            .last?
            .components(separatedBy: " ")
            .dropLast() ?? []
    }
    
    func fetchSize() -> String? {
        let fetchSizeCommand = String(format: commands.fetchSize, path)
        guard
            let rawSize = executeCommand(fetchSizeCommand)
                .components(separatedBy: "\t")
                .first?
                .trimmingCharacters(in: .whitespaces),
            let rawUnit = rawSize.last.flatMap({ "\($0)B" })
            else {
                return nil
            }
        return [String(rawSize.dropLast()), rawUnit].joined(separator: " ")
    }
    
    func fetchCreationDate() -> String? {
        let fetchCreationDateCommand = String(format: commands.fetchCreationDate, path)
        return executeCommand(fetchCreationDateCommand)
    }
    
    func fetchModificationDate() -> String? {
        let fetchModificationDateCommand = String(format: commands.fetchModificationDate, path)
        return executeCommand(fetchModificationDateCommand)
    }
    
}

private extension String {
    
    var droppingFinalCharacter: String? {
        return String(dropLast())
    }
    
}
