//
//  JWSQLiteDatabase.swift
//  SwiftAppProject
//
//  Created by XMQ on 2018/5/9.
//  Copyright © 2018年 XMQ. All rights reserved.
//

import Foundation
import FMDB

/// 默认数据库名称
public let JWSQLiteDatabase_DefaultDatabaseName = "JWSQLite.sqlite"

/// 默认数据库保存路径
public let JWSQLiteDatabase_DefaultDatabaseSavePath = NSHomeDirectory() + "/Documents/"

/// 默认数据库存储全路径
public let JWSQLiteDatabase_DefaultDatabaseFullPath = JWSQLiteDatabase_DefaultDatabaseSavePath + JWSQLiteDatabase_DefaultDatabaseName

/// 实体协议
public protocol JWSQLiteModelProtocol {
    init()
    init(_ dic:Dictionary<String,Any?>)
}


/// SQLite数据库类，一个实例对应一个具体的数据库
open class JWSQLiteDatabase: NSObject {
    /// FMDB数据库操作对象
    internal(set) var db:FMDatabase? = nil
    
    /// 数据库文件全路径
    internal(set) var dbFullPath:String? = nil
    
    /// FMDB数据库操作队列
    internal(set) lazy var dbQueue:FMDatabaseQueue = {
        let queue = FMDatabaseQueue(path: dbFullPath)
        db?.close()
        db = queue.value(forKey: "_db") as? FMDatabase
        return queue
    }()
    
    /// 数据库状态
    internal(set) var dbStatus:DatabaseStatus = .noOpen
    
    /// 数据库状态枚举
    ///
    /// - noOpen: 未打开
    /// - opening: 处于打开状态
    /// - closed: 已关闭
    enum DatabaseStatus {
        case noOpen
        case opening
        case closed
    }
    
    /// 初始化
    public required override init() {
        super.init()
        let path = JWSQLiteDatabase_DefaultDatabaseFullPath
        let fmdb:FMDatabase = FMDatabase(path: path)
        if fmdb.open() {
            db = fmdb
            dbFullPath = path
            dbStatus = .opening
        }
    }
    
    /// 初始化
    ///
    /// - Parameter dbName: 数据库名称
    public init(dbName:String) {
        super.init()
        let path = JWSQLiteDatabase_DefaultDatabaseSavePath + dbName
        let fmdb:FMDatabase = FMDatabase(path: path)
        if fmdb.open() {
            db = fmdb
            dbFullPath = path
            dbStatus = .opening
        }
    }
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - dbName: 数据库名称
    ///   - dbPath: 数据库存放目录
    public init(dbName:String,dbPath:String) {
        super.init()
        var prePath = dbPath
        if !prePath.hasSuffix("/") {
            prePath = dbPath + "/"
        }
        let path = prePath + dbName
        let fmdb:FMDatabase = FMDatabase(path: path)
        if fmdb.open() {
            db = fmdb
            dbFullPath = path
            dbStatus = .opening
        }
    }
    
    /// 检查是否存在指定的数据集合，也就是数据表
    ///
    /// - Parameter collectionName: 数据集合名称
    /// - Returns: 存在返回true，否则返回false
    public func isExistCollection(_ collectionName:String) -> Bool {
        return db!.tableExists(collectionName)
    }
    
    /// 关闭数据库，注意：数据库被关闭后，后续所有对此的数据库访问操作将会无效
    ///
    /// - Returns: 成功返回true，否则返回false
    public func close() -> Bool {
        if db != nil {
            let result = db!.close()
            if result {
                dbStatus = .closed
            }
            return result
        }
        return true
    }
    
    /// 非事务性查询队列
    ///
    /// - Parameter _: 查询队列执行动作
    public func queryQueue(_ action: (() -> (Void))) {
        dbQueue.inDatabase { _ in
            action()
        }
    }
    
    /// 事务性查询队列
    ///
    /// - Parameter _: 查询队列执行动作
    public func tranQueryQueue(_ action: ((_ rollback:UnsafeMutablePointer<ObjCBool>) -> (Void))) {
        dbQueue.inTransaction { (_, rollback:UnsafeMutablePointer<ObjCBool>) in
            action(rollback)
        }
    }
    
    /// 创建数据集合
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - model: 数据实体
    ///   - excludeColumns: 不包含的数据列，也就是指定的数据列不会创建
    /// - Returns: 成功返回true，否则返回false
    public func createCollection(_ collectionName:String,model:Any,_ excludeColumns:Array<String>? = nil) -> Bool {
        let propertyDic = convertModelPropertyTypeToColumnType(model, excludeColumns)
        return createCollection(collectionName, propertyDic)
    }
    
    /// 创建数据集合
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - dictionary: 数据列定义词典，key为数据列字段名称，value为数据列字段类型
    ///   - excludeColumns: 不包含的数据列，也就是指定的数据列不会创建
    /// - Returns: 成功返回true，否则返回false
    public func createCollection(_ collectionName:String,_ dictionary:Dictionary<String, String>,_ excludeColumns:Array<String>? = nil) -> Bool {
        let propertyDic = dictionary
        if propertyDic.keys.count == 0 {
            return false
        }
        var sql = "CREATE TABLE \(collectionName) (pkid  INTEGER PRIMARY KEY,"
        
        var keyCount = 0
        for (key, value) in propertyDic {
            keyCount = keyCount + 1
            if excludeColumns != nil {
                if excludeColumns!.contains(key) {
                    //排除掉
                    continue
                }
            }
            if key == "pkid" {
                //排除掉
                continue
            }
            if keyCount != propertyDic.count {
                sql.append(" \(key) \(value),")
            }
            else {
                sql.append(" \(key) \(value))")
            }
        }
        print("sql:\(sql)")
        return db!.executeUpdate(sql, withArgumentsIn: [])
    }
    
    /// 获取数据集合中的数据列名称数组
    ///
    /// - Parameter collectionName: 数据集合名称
    /// - Returns: 数据列名称数组
    internal func getColumnNameArrayOfCollection(_ collectionName:String) -> Array<String> {
        var retArray = Array<String>()
        let resultSet:FMResultSet = db!.getTableSchema(collectionName)
        while resultSet.next() {
            if let columnName = resultSet.string(forColumn: "name") {
                retArray.append(columnName)
            }
        }
        return retArray
    }
    
    
    /// 插入一个数据到数据集合中
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - model: 数据实体
    /// - Returns: 成功返回true，否则返回false
    public func insertCollection(_ collectionName:String,model:Any) -> Bool {
        let dic = convertModelPropertyToColumnDictionary(model, nil)
        return insertCollection(collectionName, dic)
    }
    
    /// 插入一个数据到数据集合中
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - model: 数据实体
    /// - Returns: 成功返回true，否则返回false
    public func insertCollection(_ collectionName:String,_ dictionary:Dictionary<String, Any?>) -> Bool {
        let modelDic = dictionary
        if modelDic.keys.count == 0 {
            return false
        }
        let columnNames = getColumnNameArrayOfCollection(collectionName)
        if columnNames.count == 0 {
            return false
        }
        var sql = "INSERT INTO \(collectionName) ("
        
        var subSql_1 = ""
        var subSql_2 = ""
        var keyCount = 0
        var args = Array<Any>()
        for (key, value) in modelDic {
            keyCount = keyCount + 1
            if !columnNames.contains(key) || key == "pkid" {
                //排除掉
                continue
            }
            if keyCount != modelDic.count {
                subSql_1.append("\(key),")
                if value == nil {
                    subSql_2.append("NULL,")
                }
                else {
                    subSql_2.append("?,")
                    args.append(convertPropertyValueToColumnValue(value!)!)
                }
            }
            else {
                subSql_1.append("\(key)")
                if value == nil {
                    subSql_2.append("NULL")
                }
                else {
                    subSql_2.append("?")
                    args.append(convertPropertyValueToColumnValue(value!)!)
                }
            }
        }
        sql.append("\(subSql_1)) values (\(subSql_2))")
        print("sql:\(sql)")
        return db!.executeUpdate(sql, withArgumentsIn: args)
    }
    
    /// 插入多个数据到数据集合中，不能保证所有数据都插入成功，所以如果需要保证所有数据都插入成功，可以通过事务形式调用插入一个数据到数据集合中的方法
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - model: 数据实体
    /// - Returns: 所有插入成功返回true，否则返回false
    public func insertCollection(_ collectionName:String,_ modelArray:Array<Any>) -> Bool {
        var result = true
        for model in modelArray {
            if insertCollection(collectionName, model:model) == false {
                result = false
            }
        }
        return result
    }
    
    /// 插入多个数据到数据集合中，不能保证所有数据都插入成功，所以如果需要保证所有数据都插入成功，可以通过事务形式调用插入一个数据到数据集合中的方法
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - model: 数据实体
    /// - Returns: 所有插入成功返回true，否则返回false
    public func insertCollection(_ collectionName:String,_ dictionaryArray:Array<Dictionary<String, Any?>>) -> Bool {
        var result = true
        for model in dictionaryArray {
            if insertCollection(collectionName, model) == false {
                result = false
            }
        }
        return result
    }
    
    /// 删除整个数据集合
    ///
    /// - Parameter collectionName: 数据集合名称
    /// - Returns: 成功返回true，否则返回false
    public func dropCollection(_ collectionName:String) -> Bool {
        return db!.executeUpdate("DROP TABLE \(collectionName)", withArgumentsIn: [])
    }
    
    /// 删除数据集合的数据
    ///
    /// - Parameter collectionName: 数据集合名称
    /// - Returns: 成功返回true，否则返回false
    public func deleteDataOfCollection(_ collectionName:String) -> Bool {
        return db!.executeUpdate("DELETE FROM \(collectionName)", withArgumentsIn: [])
    }
    
    /// 删除数据集合的数据
    ///
    /// - Parameter collectionName: 数据集合名称
    ///   - conditionFormat: 附加删除条件
    /// - Returns: 成功返回true，否则返回false
    public func deleteDataOfCollection(_ collectionName:String,_ conditionFormat:String) -> Bool {
        return db!.executeUpdate("DELETE FROM \(collectionName) \(conditionFormat)", withArgumentsIn: [])
    }
    
    /// 查询数据集合
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - colomnParamModel: 查询数据列参数实体，非nil属性字段有效
    ///   - conditionFormat: 附加查询条件
    /// - Returns: 成功返回结果数组，否则返回nil
    public func queryCollection<Element:JWSQLiteModelProtocol>(_ collectionName:String,_ colomnParamModel:Element? = nil,_ conditionFormat:String? = nil) -> Array<Element>? {
        var colomnParamArray:Array<String>? = nil
        if colomnParamModel != nil {
            colomnParamArray = convertModelNotNilPropertyNameToArray(colomnParamModel!)
        }
        guard let resultTemp = queryCollection(collectionName, colomnParamArray, conditionFormat) else {
            return nil
        }
        var retArray = Array<Element>()
        for item in resultTemp {
            let model:Element = Element.init(item)
            retArray.append(model)
        }
        return retArray
    }
    
    /// 查询数据集合
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - colomnParamArray: 查询数据列参数
    ///   - conditionFormat: 附加查询条件，例如“where name='user'”
    /// - Returns: 成功返回结果数组，否则返回nil
    public func queryCollection(_ collectionName:String,_ colomnParamArray:Array<String>? = nil,_ conditionFormat:String? = nil) -> Array<Dictionary<String,Any?>>? {
        var sql = "select * from \(collectionName)"
        if conditionFormat != nil {
            sql = sql + " " + conditionFormat!
        }
        let resultSet:FMResultSet? = db!.executeQuery(sql, withArgumentsIn: [])
        if resultSet == nil {
            return nil
        }
        let columnNames = getColumnNameArrayOfCollection(collectionName)
        if columnNames.count == 0 {
            return nil
        }
        var retArray = Array<Dictionary<String,Any?>>()
        while resultSet!.next() {
            var dic = Dictionary<String,Any?>()
            for index in 0..<columnNames.count {
                let key = columnNames[index]
                if colomnParamArray != nil {
                    if colomnParamArray!.contains(key) == false {
                        //排序不在查询条件的数据列
                        continue
                    }
                }
                let value = resultSet?.object(forColumn: key)
                print("value type:\(type(of: value))")
                dic[key] = value
            }
            retArray.append(dic)
        }
        return retArray
    }

    /// 更新数据集合
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - newModel: 新的数据实体
    ///   - conditionFormat: 附加更新条件
    /// - Returns: 成功返回true，否则返回false
    public func updateCollection(_ collectionName:String,newModel:Any,_ conditionFormat:String) -> Bool {
        let newDictionary = convertModelPropertyToColumnDictionary(newModel, nil)
        return updateCollection(collectionName, newDictionary, conditionFormat)
    }
    
    /// 更新数据集合
    ///
    /// - Parameters:
    ///   - collectionName: 数据集合名称
    ///   - newModel: 新的数据实体
    ///   - conditionFormat: 附加更新条件
    /// - Returns: 成功返回true，否则返回false
    public func updateCollection(_ collectionName:String,_ newDictionary:Dictionary<String,Any?>,_ conditionFormat:String? = nil) -> Bool {
        let modelDic = newDictionary
        if modelDic.keys.count == 0 {
            return false
        }
        let columnNames = getColumnNameArrayOfCollection(collectionName)
        if columnNames.count == 0 {
            return false
        }
        var sql = "UPDATE \(collectionName) SET "
        var keyCount = 0
        var args = Array<Any>()
        for (key, value) in modelDic {
            keyCount = keyCount + 1
            if !columnNames.contains(key) || key == "pkid" {
                //排除掉
                continue
            }
            if keyCount != modelDic.count {
                if value == nil {
                    sql.append("\(key)=NULL,")
                }
                else {
                    sql.append("\(key)=?,")
                    args.append(convertPropertyValueToColumnValue(value!)!)
                }
            }
            else {
                if value == nil {
                    sql.append("\(key)=NULL")
                }
                else {
                    sql.append("\(key)=?")
                    args.append(convertPropertyValueToColumnValue(value!)!)
                }
            }
        }
        if conditionFormat != nil {
            sql = sql + " " + conditionFormat!
        }
        print("sql:\(sql)")
        return db!.executeUpdate(sql, withArgumentsIn: args)
    }
}
