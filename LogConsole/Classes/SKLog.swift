import Foundation
import UIKit

// MARK: - Global functions

public struct SKLog {
    // MARK: - Variables
    
    /// Enabled or not
    public static var isEnabled: Bool = true
    
    /// The log AttributedString.
    public static var logAttrString = NSMutableAttributedString()
    /// The detailed log string.
    public static var detailedLog: String = ""
    // Did Add Log
    public static var didAddLog: (() -> ())?
    
    
    private enum LogType {
        case warning, error, debug, info
        
        var level: String {
            switch self {
            case .error: return "❌[ERROR]"
            case .warning: return "⚠️[WARNING]"
            case .info: return "💙[INFO]"
            case .debug: return "💚[DEBUG]"
            }
        }
        
        var color: UIColor {
            switch self {
            case .error: return .red
            case .warning: return .yellow
            case .info: return #colorLiteral(red: 0.2291581631, green: 0.6805399656, blue: 0.9839330316, alpha: 1)
            case .debug: return .green
            }
        }
    }
    
    // MARK: - Functions
    
    private static func log(_ items: [Any], file: String = #file, function: StaticString = #function, line: Int = #line, type: LogType) {
        guard self.isEnabled else { return }
        
        var _message = type.level + " " + message(from: items)
        if _message.hasSuffix("\n") == false {
            _message += "\n"
        }
        
        let filenameWithoutExtension = file.lastPathComponent.deletingPathExtension
        let timestamp = Date().description(dateSeparator: "-", usFormat: true, nanosecond: true)
        let logMessage = "\(timestamp) \(filenameWithoutExtension):\(line) \(function): \(_message)"
        print(logMessage, terminator: "")
        
        let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        let logString = dateString + " \(filenameWithoutExtension):\(line) " + _message
        logAttrString.append(handleLog(logString, type: type))
        didAddLog?()
        
        self.detailedLog += logMessage
    }
    
    public static func warning(_ items: Any..., file: String = #file, function: StaticString = #function, line: Int = #line) {
        self.log(items, file: file, function: function, line: line, type: .warning)
    }
    
    public static func error(_ items: Any..., file: String = #file, function: StaticString = #function, line: Int = #line) {
        self.log(items, file: file, function: function, line: line, type: .error)
    }
    
    public static func debug(_ items: Any..., file: String = #file, function: StaticString = #function, line: Int = #line) {
        self.log(items, file: file, function: function, line: line, type: .debug)
    }
    
    public static func info(_ items: Any..., file: String = #file, function: StaticString = #function, line: Int = #line) {
        self.log(items, file: file, function: function, line: line, type: .info)
    }
    
    private static func message(from items: [Any]) -> String {
        return items
            .map { String(describing: $0) }
            .joined(separator: " ")
    }
    
    private static func handleLog(_ message: String, type: LogType) -> NSAttributedString {
        let aStr = NSMutableAttributedString(string: message)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 5
        aStr.addAttributes([NSParagraphStyleAttributeName: paragraphStyle,
                            NSForegroundColorAttributeName: type.color],
                           range: NSMakeRange(0, message.characters.count))
        return aStr
    }
    
    /// Clear the log string.
    public static func clear() {
        logAttrString = NSMutableAttributedString()
        detailedLog = ""
    }
    
    /// Save the Log in a file.
    ///
    /// - Parameters:
    ///   - path: Save path.
    ///   - filename: Log filename.
    public static func saveLog(in path: String = FileManager.log,
                               filename: String = Date().YYYYMMDDDateString.appendingPathExtension("log")!) {
        if detailedLog.isEmpty { return }
        let fullPath = path.appendingPathComponent(filename)
        var logs = detailedLog
        if FileManager.default.fileExists(atPath: fullPath) {
            logs = try! String(contentsOfFile: fullPath, encoding: .utf8)
            logs = logs + detailedLog
            _ = FileManager.save(content: logs, savePath: path.appendingPathComponent(filename))
            return
        }
        FileManager.create(at: fullPath)
        _ = FileManager.save(content: logs, savePath: fullPath)
    }
}
