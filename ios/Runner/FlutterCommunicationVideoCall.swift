//
//  FlutterCommunicationVideoCall.swift
//  Runner
//
//  Created by akash on 17/01/24.
//

import Foundation
import Flutter

class FlutterCommunicationVideoCall: NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "video_call_method_channel", binaryMessenger: registrar.messenger())
        let instance = FlutterCommunicationVideoCall()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "video_call_start_function" {
            // Handle the method call
            result("Data from Swift")
            print("Inside the Swift language")
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}

