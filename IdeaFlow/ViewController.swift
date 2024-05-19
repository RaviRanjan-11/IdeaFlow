//
//  ViewController.swift
//  IdeaFlow
//
//  Created by Ravi Ranjan on 19/05/24.
//

import UIKit


class ViewController: UIViewController , UITextViewDelegate{
    
    @IBOutlet weak var textInputBox: UITextView!
    let viewModel = ViewModel()
    var currentPrefix: String = ""
    var currentRelationType: RelationType = .none
    var isOngoingRelation: Bool = false
    var lastIndexFromWhereRelationStart = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        textInputBox.delegate = self
        self.textInputBox.text = ""
    }
    
 
    func textViewDidChange(_ textView: UITextView) {
        
                
        guard let lastChar = textView.text.last else { return }
        
        if lastChar == " " {
            self.isOngoingRelation = false
            self.currentRelationType = .none
            return
        }
        
        let secondLastChar = textView.text.dropLast().last ?? " "
        
        
        switch isOngoingRelation {
        case true:
            print("Ongoing relation")
            let trimmedString = removeLeadingSpecialCharacters(from: textView.text)
            self.handleAllRelationWithCurrentOngoingRelation(currerntRelationType: currentRelationType, text: trimmedString)
        case false:
            print("Not an ongoing relation")
            self.currentRelationType = checkIfLastCharMakeARelation(lastChar: lastChar, secondLast: secondLastChar)
        }
        
    }
    
    func removeLeadingSpecialCharacters(from string: String) -> String {
       
        guard string.count > self.lastIndexFromWhereRelationStart else { return "" }
        let index = string.index(string.startIndex, offsetBy: self.lastIndexFromWhereRelationStart)
        
        return String(string[index...])
        
        
    }
    
    func checkIfLastCharMakeARelation(lastChar: Character, secondLast: Character = " ") -> RelationType {
        
        switch lastChar {
        case "#":
            self.isOngoingRelation = true
            self.lastIndexFromWhereRelationStart = textInputBox.text.count
            print("Stared a relation", RelationType.relation.description)
            return .hashTag

            
        case "@":
            self.isOngoingRelation = true
            print("Stared a relation", RelationType.relation.description)
            self.lastIndexFromWhereRelationStart = textInputBox.text.count
            return .mention
            
        case ">":
            if secondLast == "<" {
                self.isOngoingRelation = true
                print("Stared a relation", RelationType.relation.description)
                self.lastIndexFromWhereRelationStart = textInputBox.text.count

                return .relation
                
            }
            self.lastIndexFromWhereRelationStart = 0
            return .none
            
        default:
            self.lastIndexFromWhereRelationStart = 0
            return .none
        }
    }
    
    
    func handleAllRelationWithCurrentOngoingRelation(currerntRelationType: RelationType, text: String) {
        switch currentRelationType {
        case .hashTag:
            handleHashTag(string: text)
        case .mention:
            handleMention(string: text)
        case .relation:
            handleRelation(string: text)
        case .none:
            break
        }
    }
    func handleHashTag(string: String) {
        let hashTags = viewModel.getHashTagsContaining(string: string)
        print("Hash tags containing '\(currentPrefix)': \(hashTags)")
    }
    
    func handleMention(string: String) {
        let mentions = viewModel.getMentionsContaining(string: string)
        print("Mentions containing '\(currentPrefix)': \(mentions)")
    }
    func handleRelation(string: String) {
        let relations = viewModel.getRelationList(string: string)
        print("Relations: \(relations)")
    }
    
    /*
     
     issue is we need only chareteer after @ tagehel
     func removeLeadingSpecialCharacters(from string: String) -> String {
         var result = string
         let specialCharacters: Set<Character> = ["#", "@", "<", ">"]
         
         while let firstChar = result.first, specialCharacters.contains(firstChar) {
             result.removeFirst()
         }
         
         if let lastChar = result.last, lastChar == ">" {
             result.removeLast()
         }
         
         return result
     }
     */

}
