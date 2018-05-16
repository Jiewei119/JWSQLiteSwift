# JWSQLiteSwift

[![CI Status](https://img.shields.io/travis/jiewei119/JWSQLiteSwift.svg?style=flat)](https://travis-ci.org/jiewei119/JWSQLiteSwift)
[![Version](https://img.shields.io/cocoapods/v/JWSQLiteSwift.svg?style=flat)](https://cocoapods.org/pods/JWSQLiteSwift)
[![License](https://img.shields.io/cocoapods/l/JWSQLiteSwift.svg?style=flat)](https://cocoapods.org/pods/JWSQLiteSwift)
[![Platform](https://img.shields.io/cocoapods/p/JWSQLiteSwift.svg?style=flat)](https://cocoapods.org/pods/JWSQLiteSwift)

## Example

/// 一、使用Dictionary方式访问数据库

// 1、打开数据库，如果不存在会自定创建，可指定数据库名字以及存储路径

let db = JWSQLiteManager.shared.openDatabase()
print("openDatabase:\(db != nil ? true : false)")
if db == nil {
//打开数据库失败
return
}


// 2、创建数据集合，也就是数据库表

let collectionName = "User"
let createResult = db!.createCollection(collectionName, ["Account":SQLiteDataType_Text,"Password":SQLiteDataType_Text,"Birthday":SQLiteDataType_Text,"Age":SQLiteDataType_Integer,"Weight":SQLiteDataType_Real])
print("createResult:\(createResult)")
if !createResult {
//创建数据集合失败
return
}


// 3、插入数据记录到数据库

let insertResult:Bool = db!.insertCollection(collectionName, ["Account":"HJW","Password":"123456","Birthday":Date(),"Age":33,"Weight":50.0])
print("insertResult:\(insertResult)")
if !insertResult {
//创插入数据记录到数据库失败
return
}


// 4、查询指定数据集合之中的数据

if let datas = db!.queryCollection(collectionName) {
print("datas:\(datas)")
}

// 5、更新数据记录

let updateResult:Bool = db!.updateCollection(collectionName, ["Age":30], "where Account='HJW'")
print("updateResult:\(updateResult)")


// 6、检查数据库是否存在指定数据集合

let existResult = db!.isExistCollection(collectionName)
print("existResult:\(existResult)")
if existResult {
let queryResult = db!.queryCollection(collectionName)
print("queryResult:\(String(describing: queryResult))")
}


// 7、删除指定数据集合

let dropCollectionResult = db!.dropCollection(collectionName)
print("dropCollectionResult:\(dropCollectionResult)")


// 8、删除整个数据库

print("dropDB:\(JWSQLiteManager.shared.dropDatabase(db!))")


//////////////////////////////////////////////////////////////////////////////////////



/// 二、使用自定义model方式访问数据库


// 1、打开数据库，如果不存在会自定创建，可指定数据库名字以及存储路径

let db = JWSQLiteManager.shared.openDatabase()
print("openDatabase:\(db != nil ? true : false)")
if db == nil {
//打开数据库失败
return
}


// 2、创建数据集合，也就是数据库表

let collectionName = "User"
var userModel = UserModel.init()
let createResult = db!.createCollection(collectionName, model:userModel)
print("createResult:\(createResult)")
if !createResult {
//创建数据集合失败
return
}


// 3、插入数据记录到数据库

userModel = UserModel.init(["account":"HJW","password":"123456","birthday":Date(),"age":33,"weight":Float(50.0)])
let insertResult:Bool = db!.insertCollection(collectionName, model:userModel)
print("insertResult:\(insertResult)")
if !insertResult {
//创插入数据记录到数据库失败
return
}


// 4、查询指定数据集合之中的数据

if let datas = db!.queryCollection(collectionName) {
print("datas:\(datas)")
}

// 5、更新数据记录

userModel.age = 30
let updateResult:Bool = db!.updateCollection(collectionName, newModel:userModel, "where account='HJW'")
print("updateResult:\(updateResult)")


// 6、检查数据库是否存在指定数据集合

let existResult = db!.isExistCollection(collectionName)
print("existResult:\(existResult)")
if existResult {
let queryResult = db!.queryCollection(collectionName)
print("queryResult:\(String(describing: queryResult))")
}


// 7、删除指定数据集合

let dropCollectionResult = db!.dropCollection(collectionName)
print("dropCollectionResult:\(dropCollectionResult)")


// 8、删除整个数据库

print("dropDB:\(JWSQLiteManager.shared.dropDatabase(db!))")


/// 9、自定义用户实体类

class UserModel:NSObject,JWSQLiteModelProtocol {
    var account:String? = nil
    var password:String? = nil
    var age:Int? = nil
    var weight:Float? = nil
    var birthday:Date? = nil

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
                    //从数据库读取出来的格式是NSNumber，因为此字段在数据库的定义类型为INTEGER
                    age = v.intValue
                }
                
                case "weight" :
                if let v = value as? Float {
                    weight = v
                }
                else if let v = value as? NSNumber {
                    //从数据库读取出来的格式是NSNumber，因为此字段在数据库的定义类型为REAL
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
}

## Requirements

## Installation

JWSQLiteSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JWSQLiteSwift'
```

## Author

jiewei119, 810337170@qq.com

## License

JWSQLiteSwift is available under the MIT license. See the LICENSE file for more info.
