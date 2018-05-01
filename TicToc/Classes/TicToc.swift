//
//  TicToc.swift
//
//  Created by Roberto Sartori on 23.4.18.
//

import UIKit

/// TicToc class
/// This class implements simple methods to measure elapsed time (e.t.) between two events in
/// time: Tic and Toc.
/// The principle is to call the tic() function first to set the initial timestamp and
/// to call the toc() function later to get the e.t. from the initial timestamp.
///
/// A pair of static tic/toc functions are provided in order to trigger the the measurement of
/// the e.t. from wherever in the application, while a pair of instance functions are used
/// to allows multiple e.t. measurements without interfering each other.
///
/// To make the toc() return value meaningful the tic() function should be called first.
///
/// Anytime it's possible to call the tic() functino to reset the inital starting timestamp from
/// which the e.t. is computed.
public class TicToc {
    
    /// Local tic timestamp for static methods. The initial value is set to zero by default.
    static private var staticTicTime: CFAbsoluteTime = 0
    static var logEnabled: Bool = true
    
    /// Default initializer. Any instance will set its initial tic time at initialization time.
    public init() {
        self.tic()
    }
    
    /// Static tic function. Sets the starting timestamp the static toc() function will be refered to.
    public static func tic() {
        self.staticTicTime = CFAbsoluteTimeGetCurrent()
    }
    
    /// Static toc function. Returns the e.t. from the last static tic() function call.
    ///
    /// - Returns: time elapsed from the last static tic() function call.
    public static func toc() -> CFAbsoluteTime {
        return CFAbsoluteTimeGetCurrent() - self.staticTicTime
    }
    
    /// Instance timestamp set when instance tic() function is called.
    private var ticTime: CFAbsoluteTime = 0
    
    /// Instance tic function. Sets the timestamp the instance toc() function will refer to.
    public func tic() {
        ticTime = CFAbsoluteTimeGetCurrent()
    }
    
    /// Static toc function. Returns the e.t. from the last instance tic() function call.
    ///
    /// - Returns: the e.t. from the last instance tic() function call.
    public func toc() -> CFAbsoluteTime {
        return CFAbsoluteTimeGetCurrent() - ticTime
    }
    
    /// Measure the execution time of a closure. The closure is executed synchronously to the call and the log
    /// is performed at the end of the closure execution.
    /// The execution time is logged in the console
    /// prefixed by the given label. The e.t. will be printed in the following format:
    /// "<label> 2.3 sec"
    ///
    /// - Parameters:
    ///   - label: log message prefix text.
    ///   - operation: closure to be measured.
    public static func measure(label: String? = nil, operation: () -> Void) {
        let ticToc = TicToc()
        operation()
        TicToc.log(label: label, elapsed: ticToc.toc())
    }
    
    /// Measure the execution time of a closure. The closure is executed immediatly and it's responsible of
    /// calling the completion block once the measured operation is completed.
    /// prefixed by the given label. The e.t. will be printed in the following format:
    /// "<label> 2.3 sec"
    /// In order to print the execution time log message the closure must call the completion function passed
    /// as parameter as last operation.
    ///
    /// - Parameters:
    ///   - label: log message prefix text.
    ///   - operation: closure to be measured. It receives a completion block to be called when all operations
    ///            are completed
    public static func measure(label: String? = nil, operation: (@escaping () -> Void) -> Void) {
        let ticToc = TicToc()
        operation({
            TicToc.log(label: label, elapsed: ticToc.toc())
        })
    }
    
    /// Private log function. Logs the elased time message prefixed by the given label.
    ///
    /// - Parameters:
    ///   - label: log message prefix label.
    ///   - elapsed: elapsed time to log.
    private static func log(label: String?, elapsed: TimeInterval) {
        if TicToc.logEnabled {
            NSLog("\(label?.appending(" ") ?? "")\(elapsed) sec")
        }
    }
}
