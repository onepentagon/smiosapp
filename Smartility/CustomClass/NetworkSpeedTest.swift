//
//  NetworkSpeedTest.swift
//  Smartility
//
//  Created by Mani on 7/17/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation
import UIKit
import Network

enum ConnectionState: String {
    case notConnected = "Internet connection not avalable"
    case connected = "Internet connection avalable"
    case slowConnection = "Internet connection poor"
}
protocol ConnectivityDelegate: class {
    func checkInternetConnection(_ state: ConnectionState, isLowDataMode: Bool)
}

@available(iOS 12.0, *)
class Connectivity: NSObject {
    private let monitor = NWPathMonitor()
    weak var delegate: ConnectivityDelegate? = nil
    private let queue = DispatchQueue.global(qos: .background)
    private var isLowDataMode = false
    static let instance = Connectivity()
private override init() {
    super.init()
    monitor.start(queue: queue)
    startMonitorNetwork()
}
private func startMonitorNetwork() {
    monitor.pathUpdateHandler = { path in
        if #available(iOS 13.0, *) {
            self.isLowDataMode = path.isConstrained
        } else {
            // Fallback on earlier versions
            self.isLowDataMode = false
        }
        
        if path.status == .requiresConnection {
            print("requiresConnection")
                self.delegate?.checkInternetConnection(.slowConnection, isLowDataMode: self.isLowDataMode)
        } else if path.status == .satisfied {
            print("satisfied")
                 self.delegate?.checkInternetConnection(.connected, isLowDataMode: self.isLowDataMode)
        } else if path.status == .unsatisfied {
            print("unsatisfied")
                self.delegate?.checkInternetConnection(.notConnected, isLowDataMode: self.isLowDataMode)
            }
        }
    
    }
    func stopMonitorNetwork() {
        monitor.cancel()
    }
}
