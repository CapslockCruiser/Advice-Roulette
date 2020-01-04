//
//  AdviceManager.swift
//  Advice Roulette
//
//  Created by William Choi on 12/18/19.
//  Copyright © 2019 William Choi. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

final class AdviceManager {
    //https://api.adviceslip.com/#endpoint-search
    static let shared = AdviceManager();
    private let mOC: NSManagedObjectContext
    
    private let apiURL = URL(string: "https://api.adviceslip.com/advice")
    
    init() {
        mOC = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func getRandom(success: @escaping (AdviceStruct) -> ()) {
        var newAdvice: AdviceStruct? = nil
        
        guard let url = apiURL else { assertionFailure(); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error retrieving random advice")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            //let stringData = String(data: data, encoding: .utf8)
            do {
                let json = try JSON(data: data)
                let slip = json["slip"]
                guard let advice_id = Int(slip["slip_id"].stringValue) else { assertionFailure(); return }
                newAdvice = AdviceStruct(id: advice_id, content: slip["advice"].stringValue, modifieddate: Date.init())
            } catch {
                print("Couldn't parse JSON")
                return
            }
            
            success(newAdvice!) // Force unwrappnig for now
        }.resume()
        
    }
    
    func loadAllSaved() -> [AdviceStruct] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Advice")
        
        var advices: [AdviceStruct] = []
        
        do {
            let sortDescriptor = NSSortDescriptor(key: "saved_time", ascending: true)
            fetchRequest.sortDescriptors?.append(sortDescriptor)
            let fetchedResults = try mOC.fetch(fetchRequest)
            for advice in fetchedResults {
                let id = advice.value(forKey: "advice_id") as! Int
                let content = advice.value(forKey: "advice_content") as! String
                let modifieddate = advice.value(forKey: "saved_time") as! Date
                let adviceStruct = AdviceStruct(id: id, content: content, modifieddate: modifieddate)
                advices.append(adviceStruct)
            }
        } catch {
            print("Couldn't fetch results")
        }
        
        return advices
    }
    
    func save(advice: AdviceStruct) {
        
        if (adviceExists(id: advice.id)) {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Advice", in: mOC)
        guard let ent = entity else { assertionFailure(); return }
        let adviceToSave = NSManagedObject(entity: ent, insertInto: mOC)
        adviceToSave.setValue(advice.id, forKey: "advice_id")
        adviceToSave.setValue(advice.content, forKey: "advice_content")
        adviceToSave.setValue(Date.init(), forKey: "saved_time")
        saveContext()
    }

    private func saveContext() {
        do {
            try mOC.save()
        } catch {
            print("Could not save context")
        }
    }
    
    private func adviceExists(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Advice")
        fetchRequest.predicate = NSPredicate(format: "advice_id == %d", id)
        
        var result: [NSManagedObject] = []
        
        do {
            result = try mOC.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch request")
        }
        
        if result.count > 0 {
            return true
        } else {
            return false
        }
    }
    
}
