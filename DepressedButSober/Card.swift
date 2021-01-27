//
//  Card.swift
//  DepressedButSober
//
//  Created by Angelic Phan on 8/5/20.
//  Copyright © 2020 Angelic Phan. All rights reserved.
//
// This is a Card object that controls a card information. It also
// encodes its information.

import UIKit

class Card: NSObject, NSCoding, NSSecureCoding, Codable {
    
    // ****************************************************************
    // MARK: Properties
    // ****************************************************************
    
    var type: String
    var prompt: String
    var sips: Int
    
    // ****************************************************************
    // MARK: Archiving Paths
    // ****************************************************************
    
    // DocumentsDirectory stuff that indicates location for persistent
    // data storage
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveCardsURL = DocumentsDirectory.appendingPathComponent("cards")
    static let ArchiveCurrentCardURL = DocumentsDirectory.appendingPathComponent("currentCard")
    static var supportsSecureCoding: Bool = true
    
    // ****************************************************************
    // MARK: Types
    // ****************************************************************
    
    struct PropertyKey {
        static let type = "type"
        static let prompt = "prompt"
        static let sips = "sips"
    }
    
    // ****************************************************************
    // MARK: Initialization
    // ****************************************************************
    
    // This is the designated initializer
    init?(type: String, prompt: String, sips: Int) {
        // The type and prompt must not be empty
        guard !type.isEmpty || !prompt.isEmpty else {
            return nil
        }
        
        // The sips must be between 0 and 5
        guard (sips >= 0) && (sips <= 5) else {
            return nil
        }
        
        // Initialize stored properties
        self.type = type
        self.prompt = prompt
        self.sips = sips
    }
    
    // ****************************************************************
    // MARK: NSCoding
    // ****************************************************************
    
    // This function encodes the object's data
    func encode(with coder: NSCoder) {
        coder.encode(type, forKey: PropertyKey.type)
        coder.encode(prompt, forKey: PropertyKey.prompt)
        coder.encode(sips, forKey: PropertyKey.sips)
    }
    
    // This is the convenience initializer that is used for the coded
    // object
    required convenience init?(coder: NSCoder) {
        // The type is required. If we cannot decode a type string,
        // the initializer should fail
        guard let type = coder.decodeObject(forKey: PropertyKey.type) as? String else {
            return nil
        }
        
        // The prompt is required. If we cannot decode a prompt string, the initializer should fail
        guard let prompt = coder.decodeObject(forKey: PropertyKey.prompt) as? String else {
            return nil
        }
        
        // Get number of sips
        let sips = coder.decodeInteger(forKey: PropertyKey.sips)
        
        // Must call designated initializer
        self.init(type: type, prompt: prompt, sips: sips)
    }
}
