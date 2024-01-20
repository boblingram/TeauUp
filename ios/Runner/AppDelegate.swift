import UIKit
import Flutter
import SendBirdCalls

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
          
          switch(call.method){
          case "video_call_start_function":
              // Handle method call and send back the result
              // Example: Get a string argument and return its length
              if let arg = call.arguments as? [String: String] {
                  let length = arg.count
                  result(length)
                  var userId = arg["userId"] ?? ""
                  var appId = arg["appId"] ?? ""
                  print("User ID \(userId) App ID \(appId)")
                  SendBirdCall.configure(appId: "\(appId)")
                  channel.invokeMethod("show_progress", arguments: nil)
                  SendBirdCall.authenticate(with: AuthenticateParams(userId: userId, accessToken: nil)) { [self] (user, error) in
                      channel.invokeMethod("hide_progress", arguments: nil)
                      guard error == nil else {
                          controller.presentErrorAlert(message: error?.localizedDescription ?? "Failed to authenticate")
                          return
                      }
                      self?.createRoom()
                  }
              }
              print("Successfully initiated the video call")
//              let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IKDetailVC") as? SignInViewController
//              controller
//              //self.navigationController?.pushViewController(vc!, animated: true)
//              // Access the current FlutterViewController's navigation controller
//              if let navigationController = controller.navigationController {
//                  navigationController.pushViewController(vc!, animated: true)
//                } else {
//                    // If there is no navigation controller, present the view controller
//                    controller.present(vc!, animated: true, completion: nil)
//                }
              break;
          case "video_call_join_function":
              if let arg = call.arguments as? [String: String] {
                  let length = arg.count
                  result(length)
                  var userId = arg["userId"] ?? ""
                  var appId: String = arg["appId"] ?? ""
                  var roomId = arg["roomId"] ?? ""
                  print("Room Id \(roomId) User ID \(userId) App ID \(appId)")
                  SendBirdCall.configure(appId: "\(appId)")
                  channel.invokeMethod("show_progress", arguments: nil)
                  SendBirdCall.authenticate(with: AuthenticateParams(userId: userId, accessToken: nil)) { [self] (user, error) in
                      channel.invokeMethod("hide_progress", arguments: nil)
                      guard error == nil else {
                          controller.presentErrorAlert(message: error?.localizedDescription ?? "Failed to authenticate")
                          return
                      }
                      self?.joinRoom(roomId)
                  }
              }
          default:
              print("Do Nothing")
          }
      }

      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func createRoom(){
        //TODO Send Room ID once room is created
        let controller = window?.rootViewController as! FlutterViewController
        
        let channel = FlutterMethodChannel(name: "video_call_method_channel", binaryMessenger: controller.binaryMessenger)
        SendBirdCall.createRoom(with: RoomParams(roomType: .smallRoomForVideo)) { (room, error) in
            guard error == nil, let room = room else {
                controller.presentErrorAlert(message: error?.localizedDescription ?? "Failed to create a room.")
                return
            }
            
            room.enter(with: Room.EnterParams(isVideoEnabled: true, isAudioEnabled: true)) { (error) in
                guard error == nil else {
                    controller.presentErrorAlert(message: error?.localizedDescription ?? "Failed to enter a room.")
                    return
                }
                channel.invokeMethod("createdRoomID", arguments: ["roomId":"\(room.roomId)"])
                
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "roomVC") as? RoomViewController
                vc?.room = room
                              //self.navigationController?.pushViewController(vc!, animated: true)
                              // Access the current FlutterViewController's navigation controller
                              if let navigationController = controller.navigationController {
                                  print("Navigation Controller Present")
                                  navigationController.pushViewController(vc!, animated: true)
                                } else {
                                    // If there is no navigation controller, present the view controller
                                    print("Navigation Controller Not Present")
                                    controller.present(vc!, animated: true, completion: nil)
                                }
                
                //Instead of performing segue you have to do UIStoryboard initialization
                //self.performSegue(withIdentifier: "enterRoom", sender: room)
            }
        }
    }
    
    func joinRoom(_ roomId: String) {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "video_call_method_channel", binaryMessenger: controller.binaryMessenger)
        channel.invokeMethod("show_progress", arguments: nil)
        SendBirdCall.fetchRoom(by: roomId) { (room, error) in
            channel.invokeMethod("hide_progress", arguments: nil)
            guard error == nil, let room = room else {
                controller.presentErrorAlert(title: "Incorrect room ID", message: "Check your room ID and try again.", doneTitle: "OK")
                return
            }
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "joinRoomVC") as? JoinRoomViewController
            vc?.room = room
                          //self.navigationController?.pushViewController(vc!, animated: true)
                          // Access the current FlutterViewController's navigation controller
                          if let navigationController = controller.navigationController {
                              print("Navigation Controller Present")
                              navigationController.pushViewController(vc!, animated: true)
                            } else {
                                // If there is no navigation controller, present the view controller
                                print("Navigation Controller Not Present")
                                controller.present(vc!, animated: true, completion: nil)
                            }
            //controller.performSegue(withIdentifier: "joinRoom", sender: room)
        }
    }
    
}
