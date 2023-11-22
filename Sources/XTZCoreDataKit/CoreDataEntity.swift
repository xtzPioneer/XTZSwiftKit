//
//  CoreDataEntity.swift
//
//
//  Created by 张雄 on 2023/11/22.
//

import Foundation
import CoreData

/// 核心数据实体
public protocol CoreDataEntity: NSManagedObject {
    
}

/// 核心数据可转换实体
public protocol CoreDataConvertibleEntity<Model>: CoreDataEntity where Model: CoreDataConvertibleModel {
    
    /// 模型
    associatedtype Model
    
    /// 转换到模型
    /// - Returns: 模型
    func toModel() -> Model?
    
}
