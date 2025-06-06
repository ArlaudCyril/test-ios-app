//
//  WebSocket.swift
//  Lyber
//
//  Created by Apple on 26/12/22.
//

import Foundation
import UIKit
import Starscream

class WebSockets : NSObject, WebSocketDelegate, URLSessionDelegate{
	func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
	}
	
    static let sharedInstance = WebSockets()
    var isConnected : Bool = false
 
    let compression = WSCompression()

    
    override init() {
        super.init()

        openWebSocket()
    }
    func establishConnection(){
      
        
        
        var request = URLRequest(url: URL(string: ApiEnvironment.socketBaseUrl)!)
            request.timeoutInterval = 2.0
            request.httpMethod = "POST"
            request.setValue("header", forHTTPHeaderField: "Authorization")
            let socket = WebSocket(request: request)
            socket.delegate = self
            socket.connect()
        
        
        socket.onEvent = { event in
            switch event {
            case .connected(let headers):
                self.isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                self.isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)")
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                self.isConnected = false
            case .error(let error):
                self.isConnected = false
//                handleError(error)
				case .peerClosed:
					self.isConnected = false
			}
        }
    }
}

extension WebSockets {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)")
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
			case .error(_):
                isConnected = false
//                handleError(error)
			case .peerClosed:
				isConnected = false
		}
        
    }
    
    

    func openWebSocket() {
        let urlString = "wss://rtf.beta.getbux.com/subscriptions/me"
        if let url = URL(string: urlString) {
			let request = URLRequest(url: url)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            let webSocket = session.webSocketTask(with: request)
            webSocket.resume()
        }
    }

}

extension WebSockets: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web socket opened")
//        isOpened = true
    }

    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web socket closed")
//        isOpened = false
    }
}
