//
//  AdviceStruct.swift
//  Advice Roulette
//
//  Created by William Choi on 12/18/19.
//  Copyright © 2019 William Choi. All rights reserved.
//

import Foundation

final class AdviceStruct {
    var id: Int = 0
    var content: String = ""
    var modifieddate: Date
    
    init(id: Int, content: String, modifieddate: Date) {
        self.id = id
        self.content = content
        self.modifieddate = modifieddate
    }
}
