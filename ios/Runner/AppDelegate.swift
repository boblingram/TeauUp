import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      let controller = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "video_call_method_channel", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { [weak self] (call, result) in
          if call.method == "video_call_start_function" {
              // Handle method call and send back the result
              // Example: Get a string argument and return its length
              if let arg = call.arguments as? String {
                  let length = arg.count
                  result(length)
              }
              print("Successfully initiated the video call")
              let signInViewController = MainViewController()
              // Access the current FlutterViewController's navigation controller
              if let navigationController = controller.navigationController {
                  navigationController.pushViewController(signInViewController, animated: true)
                } else {
                    // If there is no navigation controller, present the view controller
                    controller.present(signInViewController, animated: true, completion: nil)
                }
          }
      }

      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
