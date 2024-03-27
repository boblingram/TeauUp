//
//  FlutterBinaryMessageSingleton.swift
//  Runner
//
//  Created by akash on 27/03/24.
//

import Foundation
import Flutter

class FlutterBinaryManager {
    static let shared = FlutterBinaryManager() // Singleton instance
    
    private var flutterMessenger: FlutterBinaryMessenger?
    
    private init() {} // Private initializer to prevent external instantiation
    
    func initFlutterEngine(tempFlutterMessenger: FlutterBinaryMessenger) {
        flutterMessenger = tempFlutterMessenger
    }
    
    func getFlutterEngine() -> FlutterBinaryMessenger {
        guard let messenger = flutterMessenger else {
            fatalError("Flutter Messenger is not initialized. Call initFlutterEngine() first.")
        }
        return messenger
    }
}
