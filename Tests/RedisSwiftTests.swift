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
        
        let set:Bool = redis.set(keyName: testKey, value: testValue)
        
        XCTAssert(set == true)
        
    }
    
    func testGetKey(){
        
        let get:String? = redis.get(keyName: testKey)
        
        XCTAssert(get == testValue)
        
    }
    
    func testDeleteKey(){
        
        let del: Bool = redis.delete(keyName: testKey)
        
        XCTAssert(del == true)
        
    }
    
    override func tearDown(){
        
        // nothing to tear down
        
    }
    
}
