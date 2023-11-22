//
//  CoreDataModel.swift
//
//
//  Created by 张雄 on 2023/11/22.
//

import Foundation
import CoreData

/// 核心数据模型
public protocol CoreDataModel {
    
    /// 托管对象ID
    var managedObjectID: NSManagedObjectID? { get }
    
}

extension NSManagedObjectID: @unchecked Sendable {
    
}

/// 核心数据可转换模型
public protocol CoreDataConvertibleModel<Entity>: CoreDataModel where Entity: CoreDataConvertibleEntity {
    
    /// 实体
    associatedtype Entity
    
    /// 转换到实体
    /// - Parameter viewContext: 视图上下文
    /// - Returns: 实体
    func toEntity(viewContext: NSManagedObjectContext) -> Entity?
    
}

