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
        let cmd = "GET \(keyName)"
    }
    
    public func set(keyName: String, value: String){
        let cmd = "SET \(keyName) \(value)"
    }
    
    public func delete(keyName: String){
        let cmd = "DEL \(keyName)"
        let (headerData, bodyData) = self.performAction(command: cmd)
    }
    
    public enum PerformError : Error {
        case curlError(Int, Data, Data)
    }
    
    private func performAction(command: String, verbose: Bool = false) -> (responseHeaderData, responseBodyData) {
        
        let url = "tcp://\(self.server):\(self.port)"
        let curl = CURL(url: url)
        
        curl.setOption(CURLOPT_UPLOAD, int: 1)
        curl.setOption(CURLOPT_USE_SSL, int: Int(CURLUSESSL_ALL.rawValue))
        
        var commandData = command.data(using: .utf8)!
        let commandBytes = [UInt8](commandData)
        
        curl.uploadBodyBytes = commandBytes
        
        if verbose {
            let commandStr = String(data: commandData, encoding: .utf8)!
            print("commandStr: \(commandStr)")
        }
        
        curl.setOption(CURLOPT_INFILESIZE, int: commandBytes.count)
        
        if verbose {
            curl.setOption(CURLOPT_VERBOSE, int: 1)
        }
        
        let (result, returnHeaderBytes, returnBodyBytes) = curl.performFully()
        
        if verbose {
            print ("curl result: \(result)")
            print ("-------")
            let strHeader = String(bytes: returnHeaderBytes, encoding: .utf8)!
            let strBody = String(bytes: returnBodyBytes, encoding: .utf8)!
            print ("-------")
            print ("curl header: \(strHeader)")
            print ("-------")
            print ("curl body: \(strBody)")
        }
        
        let responseHeaderData = Data(bytes: returnHeaderBytes)
        let responseBodyData = Data(bytes: returnBodyBytes)
        
        if result != 0 {
            throw PerformError.curlError(result, responseHeaderData, responseBodyData)
        }
        
        return (responseHeaderData, responseBodyData)
        
    }
}
