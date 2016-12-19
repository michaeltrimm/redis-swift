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
        
        self.redis = Redis(address: "localhost", port: 6379)
        
        XCTAssert(redis != nil)
    }
    
    func testSetKey(){
        
        let set:Bool = self.redis.set(keyName: self.testKey, value: self.testValue)
        
        XCTAssert(set == true)
        
    }
    
    func testGetKey(){
        
        let get:String? = self.redis.get(keyName: self.testKey)
        
        XCTAssert(get == testValue)
        
    }
    
    func testDeleteKey(){
        
        let del: Bool = self.redis.delete(keyName: self.testKey)
        
        XCTAssert(del == true)
        
    }
    
    override func tearDown(){
        
        // nothing to tear down
        
    }
    
}
