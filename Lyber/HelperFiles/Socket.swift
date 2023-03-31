//
//  Socket.swift
//  Lyber
//
//  Created by Apple on 26/12/22.
//

import Foundation
import SocketIO

//MARK:- Socket Names
class SocketNames {
    static let validuser = "validuser"
}

//MARK:- Socket Keys
class SocketKey {
    static let token = "token"
}

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient!
   // appConstantURL().BASE_URL.replacingOccurrences(of: "/api/", with: ""))!
//    var manager = SocketManager(socketURL: URL(string: ApiEnviorment.socketUrl)!, config: [.log(true), .forceWebsockets(true)])
    
    let manager = SocketManager(socketURL: URL(string: "ws://52.47.162.87/websocket/btceur")!, config: [.log(true), .compress])
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        let socketConnectionStatus = socket.status
        switch socketConnectionStatus {
        case SocketIOStatus.connected:
            print("socketValue connected")
        
        case SocketIOStatus.connecting:
            print("socketValue connecting")
        case SocketIOStatus.disconnected:
            print("socketValue disconnected")
            socket.connect()
        case SocketIOStatus.notConnected:
            print("socketValue not connected")
            socket.connect()
        }
        
        socket.once(clientEvent: .connect) { data, ack in
            print("socketValue connected")
          
//            self.validUser()
        }
    }
    
    func closeConnection() {
        socket.disconnect()
        print("socketValue disconnected Hit" )
    }
     
    func offEvent(_ name: String) {
        socket.off(name)
        print("off socketValue event: \(name)" )
    }
}


//MARK:- Socket Emitter
extension SocketIOManager{
    
    func validUser(){
        let params : [String: Any] = [SocketKey.token : userData.shared.userToken]
        socket.emit(SocketNames.validuser , params)
        print("*********************")
        print("Emitter:     validuser")
        print("param:       \(params)")
        print("*********************")
    }
//    func cancelRideBeforeDriverAccept(){
//        let params : [String: Any] = [SocketKey.token : userData.shared.accessToken ,SocketKey.rideId: rideId ?? ""]
//        socket.emit(SocketNames.cancelride, params)
//        print("*********************")
//        print("Emitter:     cancelride")
//        print("param:       \(params)")
//        print("*********************")
//    }
//    func cancelRide(){
//        let params : [String: Any] = [SocketKey.token : userData.shared.accessToken ,SocketKey.rideId: rideId ?? "",SocketKey.cancelRide : 1]
//        socket.emit(SocketNames.cancelridebyuser, params)
//        print("*********************")
//        print("Emitter:     cancelridebyuser")
//        print("param:       \(params)")
//        print("*********************")
//    }
//
//    func cancelRideReason(data : [String: Any]){
//        socket.emit(SocketNames.cancelridebyuser, data)
//        print("*********************")
//        print("Emitter:     cancelridebyuser")
//        print("param:       \(data)")
//        print("*********************")
//    }
//
//    func initializeChat(data : [String: Any]){
//        socket.emit(SocketNames.initialize, data)
//        print("*********************")
//        print("Emitter:     initialize")
//        print("param:       \(data)")
//        print("*********************")
//    }
//
//    func sendMessage(data : [String : Any]){
//        socket.emit(SocketNames.message_sent, data)
//        print("*********************")
//        print("Emitter:     message_sent")
//        print("param:       \(data)")
//        print("*********************")
//    }
//
//    func chatListing(data :[String : Any]){
//        socket.emit(SocketNames.chat_listing, data)
//        print("*********************")
//        print("Emitter:     chat_listing")
//        print("param:       \(data)")
//        print("*********************")
//    }
}

//MARK:- Socket Listner
extension SocketIOManager{
//
//    func listenDriverOnRideLoc(completionHandler: @escaping (_ messageInfo: [DriverOnRideModel]) -> Void){
//        socket.on(SocketNames.driveronrideloc){(dataArray, socketAck)-> Void in
//            print("socket listen with DriverOnRideLoc-------->>>>>>>>>>" ,dataArray)
//            do {
//                let response : [DriverOnRideModel] = try SocketParser.convert(data: dataArray)
//                completionHandler(response)
//            }catch(let error){
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func listenDriverOnRide(completionHandler: @escaping (_ messageInfo: [RideStatusModelElement]) -> Void){
//        socket.on(SocketNames.driveronride){(dataArray, socketAck)-> Void in
//            print("socket listen with driveronride-------->>>>>>>>>>" ,dataArray)
//            do {
//                let response : [RideStatusModelElement] = try SocketParser.convert(data: dataArray)
//                completionHandler(response)
//            }catch(let error){
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func listenDriverLoc(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void){
//        socket.on(SocketNames.driverloc){(dataArray, socketAck)-> Void in
//            print("socket listen with driverloc-------->>>>>>>>>>" ,dataArray)
//            print(dataArray)
//            completionHandler(dataArray[0] as! [String : AnyObject])
//        }
//    }
//
//    func listenRideStatus(completionHandler: @escaping (_ messageInfo: [RideStatusModelElement]) -> Void){
//        socket.on(SocketNames.ridestatus){(dataArray, socketAck)-> Void in
//            print("socket listen with data ridestatus ------------>>>>>",dataArray)
//            do {
//                let response : [RideStatusModelElement] = try SocketParser.convert(data: dataArray)
//                completionHandler(response)
//            }catch(let error){
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func listenerRideCancelByDriver(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void){
//        socket.on(SocketNames.cancelridebydriver){(dataArray, socketAck)-> Void in
//            print("socket listen with data cancelridebydriver ------------>>>>>",dataArray)
//            completionHandler(dataArray[0] as! Dictionary<String, AnyObject>)
//        }
//    }
//
//    func listenCancelRide(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void){
//        socket.on(SocketNames.cancelridebyuser){(dataArray, socketAck)-> Void in
//            print("socket listen with data cancelridebyuser------------>>>>>",dataArray)
//            completionHandler(dataArray[0] as! Dictionary<String, AnyObject>)
//        }
//    }
//
//    func listenCancelRideBeforeDriverAccept(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void){
//        socket.on(SocketNames.cancelride){(dataArray, socketAck)-> Void in
//            print("socket listen with data cancelRideBeforeDriverAccept------------>>>>>",dataArray)
//            completionHandler(dataArray[0] as! Dictionary<String, AnyObject>)
//        }
//    }
//
//
//    func chatMsgReceived(completion : @escaping(_ messageInfo: [ChatMessageReceive]) -> Void){
//        socket.on(SocketNames.message_received){(dataArray, socketAck)-> Void in
//            do {
//                let response : [ChatMessageReceive] = try SocketParser.convert(data: dataArray)
//                completion(response)
//            }catch(let error){
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
}
//
//class SocketTutorialManager {
//  // MARK: - Delegate
//  weak var delegate: SocketPositionManagerDelegate?
//    weak var delegate2: rideStatusProtocol?
//  // MARK: - Properties
//  let manager = SocketManager(socketURL: URL(string: appConstantURL().BASE_URL.replacingOccurrences(of: "/api/", with: ""))!, config: [.log(false), .compress])
//  var socket: SocketIOClient? = nil
//  // MARK: - Life Cycle
//  init(_ delegate: SocketPositionManagerDelegate) {
//    self.delegate = delegate
//    setupSocket()
//    setupSocketEvents()
//    socket?.connect()
//  }
//    init(_ delegate: rideStatusProtocol) {
//      self.delegate2 = delegate
//      setupSocket()
//      setupSocketEvents()
//      socket?.connect()
//    }
//  // MARK:- Remove all listeners and disconnect
//  func stopAllListeners() {
//    socket?.removeAllHandlers()
//  }
//  // MARK:- Close specific socket listener
//  func closeSocket(event: String){
//    socket?.off(event)
////    disconnect
//  }
//  // MARK: - Socket Setups
//  func setupSocket() {
//    self.socket = manager.defaultSocket
//  }
//  func setupSocketEvents() {
//    socket?.on(clientEvent: .connect) {data, ack in
//      self.delegate?.didConnect()
//    }
//    socket?.on(SocketNames.cancelride) { (data, ack) in
//      guard let dataInfo = data.first else { return }
//        print(dataInfo)
//    }
//
//    socket?.on(SocketNames.cancelridebyuser) { (data, ack) in
//      guard let dataInfo = data.first else { return }
//        print("socket listen with data cancelridebyuser------------>>>>>",dataInfo)
//        self.delegate?.listenCancelRideByUser()
//    }
////    socket?.on(SocketNames.ridestatus) {(data, ack) in
////        guard let dataInfo = data.first else { return }
////        print("socket listen with data ridestatus ------------>>>>>",dataInfo)
////        self.delegate2?.listenerRideStatus()
////    }
//  }
//  // MARK: - Socket Emits
//  func cancelRideByUserEmitter() {
//    let params : [String: Any] = [SocketKey.token : userData.shared.accessToken ,SocketKey.rideId: rideId ?? "",SocketKey.cancelRide : 1]
//    socket?.emit(SocketNames.cancelridebyuser, params)
//  }
//    func cancelRideReasonEmitter(data : [String: Any]) {
//      socket?.emit(SocketNames.cancelridebyuser, data)
//    }
//}

class SocketParser {
  static func convert<T: Decodable>(data: Any) throws -> T {
    let jsonData = try JSONSerialization.data(withJSONObject: data)
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: jsonData)
  }
  static func convert<T: Decodable>(datas: [Any]) throws -> [T] {
    return try datas.map { (dict) -> T in
      let jsonData = try JSONSerialization.data(withJSONObject: dict)
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: jsonData)
    }
  }
}

//protocol SocketPositionManagerDelegate: AnyObject {
//  func didConnect()
//  func listenCancelRideByUser()
//}
//
//protocol rideStatusProtocol: AnyObject {
//    func listenerRideStatus()
//}
//HOW TO USE
//1. var a : SocketTutorialManager?
//1.1 Confirm to delegate
//2. IN view did load or did appear add this
//a = SocketTutorialManager(self)
//3. In did appear add listener
//a!.socketChanged(position: SocketPosition(x: 0, y: 0))

// ******************************  SOCKET MODEL  ***************************************************
