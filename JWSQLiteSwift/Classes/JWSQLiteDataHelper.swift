//
//  JWSQLiteDataHelper.swift
//  SwiftAppProject
//
//  Created by XMQ on 2018/5/10.
//  Copyright © 2018年 XMQ. All rights reserved.
//

import Foundation

// 数据库中存储的数据类型
public let SQLiteDataType_Text = "TEXT" //文本
public let SQLiteDataType_Integer = "INTEGER" //int long integer ...
public let SQLiteDataType_Real = "REAL" //浮点
public let SQLiteDataType_Blob = "BLOB" //data

/// 转换实体属性类型成数据库数据列的类型
///
/// - Parameters:
///   - model: 待转换实体
///   - excludeColumns: 需要排除的数据列
/// - Returns: 转换实体属性得到的词典
internal func convertModelPropertyTypeToColumnType(_ model:Any,_ excludeColumns:Array<String>?) -> Dictionary<String, String> {
    var retDic = Dictionary<String, String>()
    let modelMirror = Mirror(reflecting: model)
    for case let (name?, value) in modelMirror.children {
        if excludeColumns != nil {
            if excludeColumns!.contains(name) {
                //排除掉
                continue
            }
        }
        let newValue = mapPropertyTypeToColumnType("\(type(of: value))")
        retDic[name] = newValue
    }
    return retDic
}

/// 映射实体属性数据类型到数据库数据类型
///
/// - Parameter type: 实体属性数据类型
/// - Returns: SQLite数据列类型
internal func mapPropertyTypeToColumnType(_ type:String) -> String {
    var retType = SQLiteDataType_Text;  //默认类型
    if type.contains("Int") {
        //整数类型
        retType = SQLiteDataType_Integer;
    }
    else if type.contains("Float") || type.contains("Double") {
        //浮点数类型
        retType = SQLiteDataType_Real;
    }
    else if type.contains("Date") {
        //日期类型
        retType = SQLiteDataType_Text;
    }
    else if type.contains("Data") {
        //Data类型
        retType = SQLiteDataType_Blob;
    }
    return retType
}

/// 转换实体属性数据值到适合数据库存储的数据值
///
/// - Parameter type: 实体属性数据值
/// - Returns: 数据库数据值
internal func convertPropertyValueToColumnValue(_ propertyValue:Any?) -> Any? {
    if propertyValue == nil {
        return nil
    }
    var columnValue:Any = propertyValue!
    let columnType = "\( type(of: columnValue))"
    if columnType == "Date" {
        columnValue = convertDateToString(columnValue as! Date)
    }
    return columnValue
}

/// 转换日期对象成字符串
///
/// - Parameter date: 日期对象
/// - Returns: 字符串
func convertDateToString(_ date:Date) -> String {
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    return dformatter.string(from: date)
}

/// 转换字符串成日期对象
///
/// - Parameter date: 日期对象
/// - Returns: 字符串
func convertDateFromString(_ dateString:String) -> Date {
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    return dformatter.date(from: dateString)!
}

/// 转换实体属性成为数据库数据列词典
///
/// - Parameters:
///   - model: 待转换实体
///   - excludeColumns: 需要排除的数据列
/// - Returns: 转换实体属性得到的词典
internal func convertModelPropertyToColumnDictionary(_ model:Any,_ excludeColumns:Array<String>?) -> Dictionary<String, Any?> {
    var retDic = Dictionary<String, Any?>()
    let modelMirror = Mirror(reflecting: model)
    for case let (name?, value) in modelMirror.children {
        if excludeColumns != nil {
            if excludeColumns!.contains(name) {
                //排除掉
                continue
            }
        }
        retDic[name] = value
    }
    return retDic
}

/// 转换非nil实体属性名称成为数组
///
/// - Parameters:
///   - model: 待转换实体
/// - Returns: 实体属性名称数组
internal func convertModelNotNilPropertyNameToArray(_ model:Any) -> Array<String> {
    var retArray = Array<String>()
    let modelMirror = Mirror(reflecting: model)
    for case let (name?, _) in modelMirror.children {
        retArray.append(name)
    }
    return retArray
}
