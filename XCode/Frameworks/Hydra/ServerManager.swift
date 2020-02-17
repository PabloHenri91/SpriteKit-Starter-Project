//
//  ServerManager.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/19/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import MultipeerConnectivity
import Foundation

class ServerManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    static let sharedInstance = ServerManager()
    
    private var anyHandler: ((_ event: String, _ peerID: MCPeerID, _ items: Any) -> Void)?
    private var handlers = [String: (MCPeerID, Any) -> Void]()
    
    var session: MCSession!
    
    var nearbyServiceBrowser: MCNearbyServiceBrowser!
    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    
    override init() {
        super.init()
        
        #if os(OSX)
            let displayName = Host.current().localizedName!
        #else
            let displayName = UIDevice.current.name
        #endif
        
        let productName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        
        let peerID = MCPeerID(displayName: displayName)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        self.session.delegate = self
        
        self.nearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: productName)
        self.nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: productName)
    }
    
    /// Adds a handler that will be called on every event.
    func onAny(_ handler: @escaping (_ event: String, _ peerID: MCPeerID, _ items: Any) -> Void) {
        self.anyHandler = handler
    }
    
    /// Adds a handler for an event.
    func on(_ event: String, callback: @escaping (_ peerID: MCPeerID, _ items: Any) -> Void) {
        self.handlers[event] = callback
    }
    
    /// Removes handler based on name
    func off(_ event: String) {
        self.handlers[event] = nil
    }
    
    /// Removes all handlers.
    /// Can be used after disconnecting to break any potential remaining retain cycles.
    func removeAllHandlers() {
        self.handlers.removeAll(keepingCapacity: false)
    }
    
    /// Send a message to the server
    func emit(_ event: String, _ items: Any...) {
        guard self.session.connectedPeers.count > 0 else { return }
        let data = try! JSONSerialization.data(withJSONObject: ["event": event, "items": items])
        try! self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
    }
    
    func startBrowsingForPeers() { // Start Server
        self.nearbyServiceAdvertiser.delegate = nil
        self.nearbyServiceAdvertiser.stopAdvertisingPeer()
        self.nearbyServiceBrowser.delegate = self
        self.nearbyServiceBrowser.startBrowsingForPeers()
    }
    
    func startAdvertisingPeer() { // Connect to server
        self.nearbyServiceBrowser.delegate = nil
        self.nearbyServiceBrowser.stopBrowsingForPeers()
        self.nearbyServiceAdvertiser.delegate = self
        self.nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    func stop() {
        self.nearbyServiceAdvertiser.delegate = nil
        self.nearbyServiceAdvertiser.stopAdvertisingPeer()
        self.nearbyServiceBrowser.delegate = nil
        self.nearbyServiceBrowser.stopBrowsingForPeers()
    }
    
    //MARK: MCSessionDelegate
    
    // Remote peer changed state.
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState){
        
        var event = ""
        
        switch state {
        case .notConnected: // Not connected to the session.
            event = "notConnected"
            break
        case .connecting: // Peer is connecting to the session.
            event = "connecting"
            break
        case .connected: // Peer is connected to the session.
            event = "connected"
            break
        }
        
        let data = try! JSONSerialization.data(withJSONObject: ["event": event])
        self.session(session, didReceive: data, fromPeer: peerID)
    }
    
    // Received data from remote peer.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        
        var jsonObject = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        let event = jsonObject["event"] as! String
        let items = jsonObject["items"] as Any
        self.anyHandler?(event, peerID, items)
        self.handlers[event]?(peerID, items)
    }
    
    // Received a byte stream from remote peer.
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        
    }
    
    // Start receiving a resource from remote peer.
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
        
    }
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    //MARK: MCNearbyServiceBrowserDelegate
    
    // Found a nearby advertising peer.
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 30)
    }
    
    
    // A nearby peer has stopped advertising.
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    
    //MARK: MCNearbyServiceAdvertiserDelegate
    
    // Incoming invitation request.  Call the invitationHandler block with YES
    // and a valid session to connect the inviting peer to the session.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
        advertiser.stopAdvertisingPeer()
        advertiser.delegate = nil
    }
}
