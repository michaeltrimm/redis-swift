//
//  Package.swift
//  RedisSwift
//
//  Created by Michael A. Trimm on 12/19/16.
//
//

import Foundation
import cURL
import PerfectCURL

public class Redis {

    public let server: String
    public var port: Int
    
    public init(address: String, port: Int = 6379){
        self.server = address
        self.port = port
    }
    
    public func get(keyName: String) -> String? {
        
    }
    
    public func set(keyName: String, value: String){
        
    }
    
    public func delete(keyName: String){
        
    }
    
    private func performAction(command: String) -> Bool {
        
        let url = "tcp://\(self.server):\(self.port)"
        let curl = CURL(url: url)
        
        
    }
}
