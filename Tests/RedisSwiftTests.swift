//
//  Package.swift
//  RedisSwift
//
//  Created by Michael A. Trimm on 12/19/16.
//
//

import Redis

class RedisSwiftTests : XCTestCase {
    
    let redis: Redis
    let testKey = "myFancyKey"
    let testValue = "something super awesome here"
    
    override func setUp(){
        super.setUp()
        
        redis = Redis(address: "localhost", port: 6379)
        
        XCTAssert(redis != nil)
    }
    
    func testSetKey(){
        
        let set:Bool = Redis.set(keyName: self.testKey, value: self.testValue)
        
        XCTAssert(set == true)
        
    }
    
    func testGetKey(){
        
        let get:String? = Redis.get(keyName: self.testKey)
        
        XCTAssert(get == testValue)
        
    }
    
    func testDeleteKey(){
        
        let del: Bool = Redis.delete(keyName: self.testKey)
        
        XCTAssert(del == true)
        
    }
    
    override func tearDown(){
        
        // nothing to tear down
        
    }
    
}
