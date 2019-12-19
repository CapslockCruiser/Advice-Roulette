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
    
    func save(advice: Advice) {
        
    }

    private func saveContext() {
        do {
            try mOC.save()
        } catch {
            print("Could not save context")
        }
    }
    
}
