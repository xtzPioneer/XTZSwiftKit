//
//  CoreDataFetcher.swift
//
//
//  Created by 张雄 on 2023/11/22.
//

import Foundation
import CoreData
import Combine

/// 私有核心数据获取器
fileprivate class _CoreDataFetcher<Model>: NSObject, NSFetchedResultsControllerDelegate where Model: CoreDataConvertibleModel {
    
    /// 获取器
    private var fetcher: NSFetchedResultsController<NSManagedObject>?
    
    /// 发布者
    private let sender: PassthroughSubject<[Model], Never>
    
    /// 发布请求结果
    /// - Parameter values: 值
    private func publishValue(_ values: [NSFetchRequestResult]?) {
        guard let values else { return }
        let results = values.compactMap {
            let entity = $0 as? Model.Entity
            let model = entity?.toModel()
            return model as? Model
        }
        sender.send(results)
    }
    
    /// 获取数据
    /// - Parameters:
    ///   - viewContext: 视图上下文
    ///   - request: 请求
    func fetch(viewContext: NSManagedObjectContext, request: NSFetchRequest<Model.Entity>) {
        precondition(viewContext.concurrencyType == .mainQueueConcurrencyType, "只支持类型为MainQueue的托管对象上下文")
        fetcher = NSFetchedResultsController(fetchRequest: request as! NSFetchRequest<NSManagedObject>, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetcher?.delegate = self
        do {
            try fetcher?.performFetch()
        } catch {
            fatalError("执行请求出错：\(error.localizedDescription)")
        }
        publishValue(fetcher?.fetchedObjects)
    }
    
    /// 初始化
    /// - Parameter sender: 发布者
    init(sender: PassthroughSubject<[Model], Never>) {
        self.sender = sender
    }
    
    /// 内容已经更改
    /// - Parameter controller: 控制器
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        publishValue(controller.fetchedObjects)
    }
    
}

/// 核心数据获取器
open class CoreDataFetcher<Model>: NSObject, NSFetchedResultsControllerDelegate where Model: CoreDataConvertibleModel {
    
    /// 核心数据获取器
    private var fetcher: _CoreDataFetcher<Model>
    
    /// 获取数据
    /// - Parameters:
    ///   - viewContext: 视图上下文
    ///   - request: 请求
    public func fetch(viewContext: NSManagedObjectContext, request: NSFetchRequest<Model.Entity>) {
        fetcher.fetch(viewContext: viewContext, request: request)
    }
    
    // 初始化
    /// - Parameter sender: 发布者
    public init(sender: PassthroughSubject<[Model], Never>) {
        self.fetcher = .init(sender: sender)
    }
    
}
