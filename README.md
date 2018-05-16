# JWSQLiteSwift

[![CI Status](https://img.shields.io/travis/jiewei119/JWSQLiteSwift.svg?style=flat)](https://travis-ci.org/jiewei119/JWSQLiteSwift)
[![Version](https://img.shields.io/cocoapods/v/JWSQLiteSwift.svg?style=flat)](https://cocoapods.org/pods/JWSQLiteSwift)
[![License](https://img.shields.io/cocoapods/l/JWSQLiteSwift.svg?style=flat)](https://cocoapods.org/pods/JWSQLiteSwift)
[![Platform](https://img.shields.io/cocoapods/p/JWSQLiteSwift.svg?style=flat)](https://cocoapods.org/pods/JWSQLiteSwift)

## Example

<p>
	<div style="font-family:Verdana;font-size:14px;">
		/// 一、使用Dictionary方式访问数据库
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 1、打开数据库，如果不存在会自定创建，可指定数据库名字以及存储路径
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let db = JWSQLiteManager.shared.openDatabase()
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("openDatabase:\(db != nil ? true : false)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if db == nil {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; //打开数据库失败
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; return
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 2、创建数据集合，也就是数据库表
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let collectionName = "User"
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let createResult = db!.createCollection(collectionName, ["Account":SQLiteDataType_Text,"Password":SQLiteDataType_Text,"Birthday":SQLiteDataType_Text,"Age":SQLiteDataType_Integer,"Weight":SQLiteDataType_Real])
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("createResult:\(createResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if !createResult {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; //创建数据集合失败
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; return
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 3、插入数据记录到数据库
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let insertResult:Bool = db!.insertCollection(collectionName, ["Account":"HJW","Password":"123456","Birthday":Date(),"Age":33,"Weight":50.0])
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("insertResult:\(insertResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if !insertResult {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; //创插入数据记录到数据库失败
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; return
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 4、查询指定数据集合之中的数据
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if let datas = db!.queryCollection(collectionName) {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; print("datas:\(datas)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 5、更新数据记录
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let updateResult:Bool = db!.updateCollection(collectionName, ["Age":30], "where Account='HJW'")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("updateResult:\(updateResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 6、检查数据库是否存在指定数据集合
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let existResult = db!.isExistCollection(collectionName)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("existResult:\(existResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if existResult {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; let queryResult = db!.queryCollection(collectionName)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; print("queryResult:\(String(describing: queryResult))")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 7、删除指定数据集合
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let dropCollectionResult = db!.dropCollection(collectionName)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("dropCollectionResult:\(dropCollectionResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 8、删除整个数据库
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("dropDB:\(JWSQLiteManager.shared.dropDatabase(db!))")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		//////////////////////////////////////////////////////////////////////////////////////
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		/// 二、使用自定义model方式访问数据库
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 1、打开数据库，如果不存在会自定创建，可指定数据库名字以及存储路径
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let db = JWSQLiteManager.shared.openDatabase()
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("openDatabase:\(db != nil ? true : false)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if db == nil {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; //打开数据库失败
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; return
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 2、创建数据集合，也就是数据库表
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let collectionName = "User"
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		var userModel = UserModel.init()
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let createResult = db!.createCollection(collectionName, model:userModel)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("createResult:\(createResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if !createResult {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; //创建数据集合失败
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; return
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 3、插入数据记录到数据库
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		userModel = UserModel.init(["account":"HJW","password":"123456","birthday":Date(),"age":33,"weight":Float(50.0)])
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let insertResult:Bool = db!.insertCollection(collectionName, model:userModel)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("insertResult:\(insertResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if !insertResult {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; //创插入数据记录到数据库失败
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; return
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 4、查询指定数据集合之中的数据
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if let datas = db!.queryCollection(collectionName) {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; print("datas:\(datas)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 5、更新数据记录
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		userModel.age = 30
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let updateResult:Bool = db!.updateCollection(collectionName, newModel:userModel, "where account='HJW'")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("updateResult:\(updateResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 6、检查数据库是否存在指定数据集合
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let existResult = db!.isExistCollection(collectionName)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("existResult:\(existResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		if existResult {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; let queryResult = db!.queryCollection(collectionName)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; print("queryResult:\(String(describing: queryResult))")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 7、删除指定数据集合
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		let dropCollectionResult = db!.dropCollection(collectionName)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("dropCollectionResult:\(dropCollectionResult)")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		// 8、删除整个数据库
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		print("dropDB:\(JWSQLiteManager.shared.dropDatabase(db!))")
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		/// 9、自定义用户实体类
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		class UserModel:NSObject,JWSQLiteModelProtocol {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; var account:String? = nil
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; var password:String? = nil
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; var age:Int? = nil
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; var weight:Float? = nil
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; var birthday:Date? = nil
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; required override init() {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		<br />
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; required init(_ dic: Dictionary&lt;String, Any?&gt;) {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; for (key,value) in dic {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; switch key {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case "account" :
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; account = value as? String
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case "password" :
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; password = value as? String
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case "age" :
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if let v = value as? Int {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; age = v
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; else if let v = value as? NSNumber {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; //从数据库读取出来的格式是NSNumber，因为此字段在数据库的定义类型为INTEGER
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; age = v.intValue
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case "weight" :
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if let v = value as? Float {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; weight = v
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; else if let v = value as? NSNumber {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; //从数据库读取出来的格式是NSNumber，因为此字段在数据库的定义类型为REAL
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; weight = v.floatValue
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case "birthday" :
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; let date = value as? Date
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; birthday = date
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if date == nil &amp;&amp; value != nil {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; let temp = value!
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if let timeStr:NSString = temp as? NSString {
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; //从数据库读取出来的格式是NSString，因为此字段在数据库的定义类型为TEXT
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; let timeInterval = timeStr.doubleValue
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; birthday = Date.init(timeIntervalSince1970: timeInterval)
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; default:
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; break
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; &nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		&nbsp; &nbsp; }
	</div>
	<div style="font-family:Verdana;font-size:14px;">
		}
	</div>
</p>
<p>
	<br />
</p>
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
