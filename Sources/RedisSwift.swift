/**
 * Copyright (c) 2016 Michael A Trimm
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import cURL
import PerfectCURL

public class Redis {

    public let server: String
    public var port: Int

    /**
     Redis client interface
     
     - Author:
     Michael A. Trimm <michael@michaeltrimm.com>
     
     - parameters:
        - address: host address of redis server
        - port: listening port for the redis instance connecting to
    */
    public init(address: String = "localhost", port: Int = 6379) {
        server = address
        port = port
    }

    /**
     Get a stored value by its key
    
     - Author:
     Michael A. Trimm <michael@michaeltrimm.com>
 
     - parameters:
        - keyName: Name of the key stored in redis
 
     - throws:
     An error of type PerformError should the cURL call fail
     
     - returns:
     If the key exists, return its value, otherwise return nil
    */
    public func get(keyName: String) throws -> String? {
        let cmd = "GET \(keyName)"

        do {

            let (headerData, bodyData) = try performAction(command: cmd)

            guard let value = String(bytes: bodyData, encoding: .utf8) else {
                return nil
            }

            return value

        } catch PerformError.curlError {
            return nil
        }

    }

    /**
     Set (or create) a new record in Redis
     
     - Author:
     Michael A. Trimm <michael@michaeltrimm.com>
     
     - parameters:
        - keyName: Name to retrieve this key->value pair
        - value: Value to store in the key->value pair 
     
     - throws:
     An error of type PerformError should the cURL call fail
     
     - returns:
     true or false depending on if the set was successful
    */
    public func set(keyName: String, value: String) throws -> Bool {
        let cmd = "SET \(keyName) \(value)"

        do {

            let (headerData, bodyData) = try performAction(command: cmd)
            guard let body: String = String(bytes: bodyData, encoding: .utf8) else {
                return false
            }

            return (body == "+OK" || body == "+OK\n")

        } catch PerformError.curlError {
            return false
        }

    }

    /**
     Delete a stored key from the Redis server
     
     - Author:
     Michael A. Trimm <michael@michaeltrimm.com>
     
     - parameters:
        - keyName: Name of the key that should be deleted
     
     - throws:
     An error of type PerformError should the cURL call fail
     
     - returns:
     true or false depending on if the key was actually deleted
     (if the key does not exist, this will return true)
    */
    public func delete(keyName: String) -> Bool {
        let cmd = "DEL \(keyName)"

        do {
            let (headerData, bodyData) = try performAction(command: cmd)
        } catch PerformError.curlError {
            return false
        }

    }

    /**
     Extending the Error type for class-specific error responses
    */
    public enum PerformError: Error {
        case curlError(Int, Data, Data)
    }

    /**
     Responsible for creating the cURL object, inserting the command, executing the
     command and formatting the response
     
     - Author: 
     Michael A. Trimm <michael@michaeltrimm.com>
     
     - parameters:
        - command: Full redis command to be executed
        - verbose: Boolean toggle to display debug data from cURL call 
     
     - throws:
     An error of type PerformError should the cURL call fail
     
     - returns:
     tuple of cURL response header data and body data
    */
    private func performAction(command: String, verbose: Bool = false) throws
        -> (responseHeaderData, responseBodyData) {

        let url = "tcp://\(server):\(port)"
        let curl = CURL(url: url)

        curl.setOption(CURLOPT_UPLOAD, int: 1)
        curl.setOption(CURLOPT_USE_SSL, int: Int(CURLUSESSL_ALL.rawValue))

        guard var commandData = command.data(using: .utf8) else {
            print("Unable to convert commandData to an array of bytes")
            return (nil, nil)
        }
        let commandBytes = [UInt8](commandData)

        curl.uploadBodyBytes = commandBytes

        if verbose {
            guard let commandStr = String(data: commandData, encoding: .utf8) else {
                print("Failed to convert commandData to a String")
            }
            print("commandStr: \(commandStr)")
        }

        curl.setOption(CURLOPT_INFILESIZE, int: commandBytes.count)

        if verbose {
            curl.setOption(CURLOPT_VERBOSE, int: 1)
        }

        let (result, rHeaderBytes, rBodyBytes) = curl.performFully()

        if verbose {
            print ("curl result: \(result)")
            print ("-------")
            guard let strHeader = String(bytes: rHeaderBytes, encoding: .utf8) else {
                print("Unable to convert returnHeaderBytes into a String")
            }
            guard let strBody = String(bytes: rBodyBytes, encoding: .utf8) else {
                print("Unable to convert returnBodyBytes into a String")
            }
            print ("-------")
            print ("curl header: \(strHeader)")
            print ("-------")
            print ("curl body: \(strBody)")
        }

        let responseHeaderData = Data(bytes: rHeaderBytes)
        let responseBodyData = Data(bytes: rBodyBytes)

        if result != 0 {
            throw PerformError.curlError(result, rHeaderBytes, rBodyBytes)
        }

        return (responseHeaderData, responseBodyData)
    }
}
