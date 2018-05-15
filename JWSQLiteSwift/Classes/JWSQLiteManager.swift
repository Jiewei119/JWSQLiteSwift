//
//  JWSQLiteManager.swift
//  SwiftAppProject
//
//  Created by XMQ on 2018/5/9.
//  Copyright © 2018年 XMQ. All rights reserved.
//

import UIKit
import FMDB

/// SQLite数据库管理器
public class JWSQLiteManager: NSObject {
    public static let shared = JWSQLiteManager() //SQLite数据库管理器类单例
    
    /// 打开默认数据库，不存在会自动创建，存放于NSDocumentDirectory目录下
    ///
    /// - Parameter dbName: 数据库名称，默认存放于NSDocumentDirectory目录下
    /// - Returns: 成功返回数据库实例，失败返回nil
    public func openDatabase() -> JWSQLiteDatabase? {
        let db = JWSQLiteDatabase()
        if db.db != nil {
            return db
        }
        return nil
    }
    
    /// 打开数据库，不存在会自动创建
    ///
    /// - Parameter dbName: 数据库名称，默认存放于NSDocumentDirectory目录下
    /// - Returns: 成功返回数据库实例，失败返回nil
    public func openDatabase(_ dbName:String) -> JWSQLiteDatabase? {
        let db = JWSQLiteDatabase(dbName: dbName)
        if db.db != nil {
            return db
        }
        return nil
    }
    
    /// 打开数据库，不存在会自动创建
    ///
    /// - Parameter dbName: 数据库名称，默认存放于NSDocumentDirectory目录下
    /// - Parameter dbName: 数据库存放目录路径
    /// - Returns: 成功返回数据库实例，失败返回nil
    public func openDatabase(_ dbName:String,_ dbPath:String) -> JWSQLiteDatabase? {
        let db = JWSQLiteDatabase(dbName: dbName,dbPath:dbPath)
        if db.db != nil {
            return db
        }
        return nil
    }
    
    /// 关闭数据库
    ///
    /// - Parameter db: 数据库实例
    public func closeDatabase(_ db:JWSQLiteDatabase) -> Bool {
        return db.close()
    }
    
    /// 删除数据库
    ///
    /// - Parameter db: 数据库实例
    public func dropDatabase(_ db:JWSQLiteDatabase) -> Bool {
        if db.dbStatus == .opening {
            //数据库正处于打开状态，需要先关闭
            if !db.close() {
                return false
            }
        }
        
        if let dbFullPath = db.dbFullPath {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: dbFullPath) {
                return true
            }
            do {
                try fileManager.removeItem(atPath: dbFullPath)
                return !fileManager.fileExists(atPath: dbFullPath)
            } catch {
                return false
            }
        }
        else {
            return false
        }
    }
}
