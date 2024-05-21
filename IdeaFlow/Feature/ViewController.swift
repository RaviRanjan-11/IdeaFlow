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
    var suggestions: [String] = []

    
    
    private var matchingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MatchingTableViewCell.self, forCellReuseIdentifier: "MatchingTableViewCell")
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var matchingTableViewLeadingConstraint: NSLayoutConstraint?
    var matchingTableViewTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTextView()
        self.configureMatchingTableView()
    }
    
    
    func configureMatchingTableView() {
        matchingTableView.delegate = self
        matchingTableView.dataSource = self
        view.addSubview(matchingTableView)

        matchingTableViewLeadingConstraint = matchingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
           matchingTableViewTopConstraint = matchingTableView.topAnchor.constraint(equalTo: view.topAnchor)
           
           NSLayoutConstraint.activate([
               matchingTableViewLeadingConstraint!,
               matchingTableViewTopConstraint!,
               matchingTableView.widthAnchor.constraint(equalTo: textInputBox.widthAnchor, multiplier: 0.5),
               matchingTableView.heightAnchor.constraint(equalToConstant: 200)
           ])
    }
 
    
    func configureTextView() {
        textInputBox.delegate = self
        self.textInputBox.text = ""
        self.textInputBox.becomeFirstResponder()
    }
    
    
    func positionSuggestionTableView() {
        guard let selectedTextRange = textInputBox.selectedTextRange else { return }
        
        // Get the caret rectangle in the text view's coordinate system
        let caretRect = textInputBox.caretRect(for: selectedTextRange.start)
        
        // Convert the caret rectangle to the main view's coordinate system
        let caretRectInSuperview = textInputBox.convert(caretRect, to: self.view)
        
        // Calculate the maximum allowed x position for the table view
        let maxAllowedX = self.view.frame.width * 0.75
        let tableViewWidth = textInputBox.frame.width / 2
        
        // Determine the new x position for the table view
        var newXPosition = caretRectInSuperview.origin.x
        
        // If the x position exceeds the maximum allowed, adjust it
        if newXPosition > maxAllowedX {
            newXPosition = maxAllowedX - tableViewWidth / 2
        }
        
        // Update the leading and top constraints
        matchingTableViewLeadingConstraint?.constant = newXPosition
        matchingTableViewTopConstraint?.constant = caretRectInSuperview.maxY
        
        // Show the table view
        matchingTableView.isHidden = false
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
            self.suggestions = []
            self.matchingTableView.isHidden = true
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
        updateSuggestions(with: hashTags)
    }
    
    func handleMention(string: String) {
        let mentions = viewModel.getMentionsContaining(string: string)
        print("Mentions containing '\(currentPrefix)': \(mentions)")
        updateSuggestions(with: mentions)

    }
    func handleRelation(string: String) {
        let relations = viewModel.getRelationList(string: string)
        print("Relations: \(relations)")
        updateSuggestions(with: relations)

    }
    
    func updateSuggestions(with data: [String]) {
        if data.isEmpty {
            matchingTableView.isHidden = true
        } else {
            // Assuming you have a data source array for the table view
            self.suggestions = data
            matchingTableView.reloadData()
            positionSuggestionTableView()
        }
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


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchingTableViewCell", for: indexPath) as? MatchingTableViewCell else {
            return UITableViewCell()
        }
        let suggestion = suggestions[indexPath.row]
        cell.textLabel?.text = suggestion
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = suggestions[indexPath.row]
        
        self.removeLastCharacterFromTextView()
        self.textInputBox.text.append(selectedSuggestion)
        self.updateTextField()
        
    }
    
   
    func removeLastCharacterFromTextView() {
        if var text = textInputBox.text, !text.isEmpty {
            text.removeLast()
            textInputBox.text = text
        }
    }
    
    func updateTextField() {
        let wholeText = self.textInputBox.text as NSString
        let words:[String] = wholeText.components(separatedBy: " ")
        
        let attrs = [
            NSAttributedString.Key.font : UIFont.init(name: "HelveticaNeue", size: 13),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        
        let attrString = NSMutableAttributedString(string: (wholeText) as String, attributes: attrs as [NSAttributedString.Key : Any])
        
        for word in words {
            if word.hasPrefix("#") || word.hasPrefix("@") || word.hasPrefix(">") || word.hasPrefix("<") {
                let matchRange:NSRange = wholeText.range(of: word as String)
                var stringifiedWord:String = word as String
                stringifiedWord = String(stringifiedWord.dropFirst())
                
                var attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.blue
                ]
                
                // Check if the word is enclosed within "<>"
                if word.hasPrefix("<") && word.hasSuffix(">") {
                    attributes[NSAttributedString.Key.backgroundColor] = UIColor.yellow
                    stringifiedWord = stringifiedWord.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
                }
                
                attrString.addAttributes(attributes, range: matchRange)
                self.textInputBox.attributedText = attrString
            }
        }
        self.suggestions = []
        self.matchingTableView.isHidden = true
    }

}




























/*
 func insertSuggestionIntoTextView(_ suggestion: String) {
     guard let selectedTextRange = textInputBox.selectedTextRange else { return }
     
     removeLastCharacterFromTextView()
     
     
     
     guard let creted = self.createAttributedString(with: suggestion,fontSize: 16, backgroundColor: .red) else {return}
     self.appendAttributedString(to: self.textInputBox, with: creted)
     
     guard let addspace = self.createAttributedString(with: " ") else {
         print("err")
         return}
     
     self.appendAttributedString(to: self.textInputBox, with: addspace)

     
     self.suggestions = []
     
     self.matchingTableView.isHidden = true
 }
 
 
 func removeLastCharacterFromTextView() {
     if var text = textInputBox.text, !text.isEmpty {
         text.removeLast()
         textInputBox.text = text
     }
 }
 
 
 func createAttributedString(with string: String, fontSize: CGFloat = 12, backgroundColor:UIColor = .white) -> NSAttributedString? {
     
     var modifiedString = string
     let attr = NSMutableAttributedString(string: modifiedString)
     
     let range = NSRange(location: 0, length: attr.length)
     
     attr.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: range)

     attr.addAttribute(.backgroundColor, value: backgroundColor, range: range)
     return attr
 }

 func appendAttributedString(to textView: UITextView, with attributedString: NSAttributedString) {
     // Append the attributed string to the existing text
     let mutableAttributedString = NSMutableAttributedString(attributedString: textView.attributedText ?? NSAttributedString())
     mutableAttributedString.append(attributedString)
     textView.attributedText = mutableAttributedString
     
     // Reset the font of the entire text view to the default font size
 }

 */
