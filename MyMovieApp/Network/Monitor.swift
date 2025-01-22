//
//  Monitor.swift
//  MyMovieApp
//
//  Created by ali cihan on 3.01.2025.
//

import Foundation
import Network

enum NetworkStatus: String {
    case unknown
    case connected
    case disconnected
}

class Monitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    @Published var status: NetworkStatus = .unknown

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if path.status == .satisfied {
                    debugPrint("Connected!")
                    self.status = .connected
                } else {
                    debugPrint("No connection.")
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
}
