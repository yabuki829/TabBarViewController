//
//  File.swift
//  
//
//  Created by 薮木翔大 on 2023/01/07.
//

import Foundation
open class TabTagManager{
    
    static let shared = TabTagManager()
    private let userDefaluts = UserDefaults.standard
    private let tags = [TabTag]()
    
    func save(tags:[TabTag]){
        // tagsをjsonに変更して保存する
        let data = convertData(tags: tags)
        userDefaluts.setValue(data, forKey: "tabtag")
        
        
    }
    
    /// index番目のtagを削除する。
    func delete(index:Int){
        var tags = get()
        tags.remove(at: index)
    }

    func add(tag:TabTag){
        var tags = get()
        tags.append(tag)
    }
    
    func get() -> [TabTag]{
        return getObject()
    }
    
    
    func edit(index:Int ,_ tag:TabTag){
        var tags = get()
        tags[index] = tag
    }
    
    private func convertData(tags:[TabTag]) -> Data{
        let data = try! JSONEncoder().encode(tags)
        return data
    }
    
    private func getObject()-> [TabTag]{
        
        guard let data = userDefaluts.data(forKey: "tabtag") else { return [TabTag]()}
        let tabs = try? JSONDecoder().decode([TabTag].self, from: data)
       
        return tabs ?? [TabTag]()
    }
    
    
    
}

