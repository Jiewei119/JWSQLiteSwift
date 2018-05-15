//
//  ViewController.swift
//  JWSQLiteSwift
//
//  Created by jiewei119 on 05/15/2018.
//  Copyright (c) 2018 jiewei119. All rights reserved.
//

import UIKit
import JWSQLiteSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        testDB()
        testDB2()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

func testDB() {
    let db = JWSQLiteManager.shared.openDatabase()
    print("openDatabase:\(db != nil ? true : false)")
    if db != nil {
        var createResult:Bool = false
        let collectionName = "User"
        
        createResult = db!.createCollection(collectionName, ["Account":SQLiteDataType_Text,"Password":SQLiteDataType_Text,"Birthday":SQLiteDataType_Text,"Age":SQLiteDataType_Integer,"Weight":SQLiteDataType_Real])
        print("createResult:\(createResult)")
        if createResult {
            let insertResult:Bool = db!.insertCollection(collectionName, ["Account":"HJW","Password":"123456","Birthday":Date(),"Age":33,"Weight":50.0])
            print("insertResult:\(insertResult)")
            if insertResult {
                if let datas = db!.queryCollection(collectionName) {
                    print("datas:\(datas)")
                }
            }
            let updateResult:Bool = db!.updateCollection(collectionName, ["Age":30], "where Account='HJW'")
            print("updateResult:\(updateResult)")
        }
        
        let existResult = db!.isExistCollection(collectionName)
        print("existResult:\(existResult)")
        if existResult {
            let queryResult = db!.queryCollection(collectionName)
            print("queryResult:\(String(describing: queryResult))")
        }
        
        let dropCollectionResult = db!.dropCollection(collectionName)
        print("dropCollectionResult:\(dropCollectionResult)")
        
        print("dropDB:\(JWSQLiteManager.shared.dropDatabase(db!))")
    }
}

func testDB2() {
    let db = JWSQLiteManager.shared.openDatabase()
    print("openDatabase:\(db != nil ? true : false)")
    if db != nil {
        var createResult:Bool = false
        let collectionName = "User"
        
        var userModel = UserModel.init()
        createResult = db!.createCollection(collectionName, model:userModel)
        print("createResult:\(createResult)")
        if createResult {
            userModel = UserModel.init(["account":"HJW","password":"123456","birthday":Date(),"age":33,"weight":Float(50.0)])
            let insertResult:Bool = db!.insertCollection(collectionName, model:userModel)
            print("insertResult:\(insertResult)")
            if insertResult {
                if let datas = db!.queryCollection(collectionName) {
                    print("datas:\(datas)")
                }
            }
            userModel.age = 30
            let updateResult:Bool = db!.updateCollection(collectionName, newModel:userModel, "where account='HJW'")
            print("updateResult:\(updateResult)")
        }
        
        let existResult = db!.isExistCollection(collectionName)
        print("existResult:\(existResult)")
        if existResult {
            let queryResult = db!.queryCollection(collectionName,userModel)
            print("queryResult:\(String(describing: queryResult))")
        }
        
        let dropCollectionResult = db!.dropCollection(collectionName)
        print("dropCollectionResult:\(dropCollectionResult)")
        
        print("dropDB:\(JWSQLiteManager.shared.dropDatabase(db!))")
    }
}

class UserModel:NSObject,JWSQLiteModelProtocol {
    required override init() {
        
    }
    required init(_ dic: Dictionary<String, Any?>) {
        for (key,value) in dic {
            switch key {
            case "account" :
                account = value as? String
            case "password" :
                password = value as? String
            case "age" :
                if let v = value as? Int {
                    age = v
                }
                else if let v = value as? NSNumber {
                    age = v.intValue
                }
            case "weight" :
                if let v = value as? Float {
                    weight = v
                }
                else if let v = value as? NSNumber {
                    weight = v.floatValue
                }
            case "birthday" :
                let date = value as? Date
                birthday = date
                if date == nil && value != nil {
                    let temp = value!
                    if let timeStr:NSString = temp as? NSString {
                        //从数据库读取出来的格式是NSString，因为此字段在数据库的定义类型为TEXT
                        let timeInterval = timeStr.doubleValue
                        birthday = Date.init(timeIntervalSince1970: timeInterval)
                    }
                }
            default:
                break
            }
        }
    }
    
    var account:String? = nil
    var password:String? = nil
    var age:Int? = nil
    var weight:Float? = nil
    var birthday:Date? = nil
}

