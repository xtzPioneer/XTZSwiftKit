//
//  CoreDataStack.swift
//
//
//  Created by 张雄 on 2023/11/22.
//

import Foundation
import CoreData

/// 核心数据堆栈
public protocol CoreDataStack {
    
    /// 视图上下文
    var viewContext: NSManagedObjectContext { get }
    
    /// 保存数据
    /// - Parameter viewContext: 视图上下文
    /// - Returns: 保存结果
    func save(viewContext: NSManagedObjectContext) -> Result<Void, Error>
    
    /// 删除数据
    /// - Parameters:
    ///   - viewContext: 视图上下文
    ///   - managedObjectID: 托管对象ID
    func delete(viewContext: NSManagedObjectContext, managedObjectID: NSManagedObjectID) throws

    /// 执行后台任务
    /// - Parameter block: 闭包
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async rethrows -> T
    
}

