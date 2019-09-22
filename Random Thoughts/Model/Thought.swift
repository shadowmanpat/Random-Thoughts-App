//
//  Thought.swift
//  Random Thoughts
//
//  Created by Nikolaos Agas on 21/09/2019.
//  Copyright © 2019 Nikolaos Agas. All rights reserved.
//

import Foundation
import Firebase


class Thought {
    private (set) var username : String!
    private (set) var timestamp : Date!
    private (set) var thoughtTxt : String!
    private (set) var numlikes : Int!
    private (set) var numComments : Int!
    private (set) var documentId : String!
    private (set) var userId: String!
    private (set) var category: String!
    
    init(username: String, timestamp : Date, thoughtTxt: String, numlikes: Int, numComments: Int, documetnId: String, userId: String, category: String) {
            self.username = username
        self.timestamp = timestamp
        self.thoughtTxt = thoughtTxt
        self.numlikes = numlikes
        self.numComments = numComments
        self.documentId = documetnId
        self.userId = userId
        self.category = category
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Thought]{
        var thoughts = [Thought]()
        guard let snap = snapshot else {return thoughts}
        for document in snap.documents {
            print(document.data())
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            let timestamp =  data[TIMESTAMP] as? Date ?? Date()
            print("timestamp \(String(describing: data[TIMESTAMP])) \(timestamp)" )
            let thouthText = data[THOUGHT_TXT] as? String ?? ""
            let numLikes = data[NUM_LIKES] as? Int ?? 0
            let numComments = data[NUM_COMMENTS] as? Int ?? 0
            let documentId = document.documentID
            let userId = data[USER_ID] as? String ?? " "
            let category = data[CATEGORY] as? String ?? " "
            let newThought = Thought(username: username, timestamp: timestamp, thoughtTxt: thouthText, numlikes: numLikes, numComments: numComments, documetnId: documentId, userId: userId, category: category)
            thoughts.append(newThought)

        }
        return thoughts
    }
}
