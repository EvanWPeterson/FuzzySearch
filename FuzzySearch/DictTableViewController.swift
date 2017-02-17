//
//  DictTableViewController.swift
//  FuzzySearch
//
//  Created by Evan Peterson on 2/17/17.
//  Copyright © 2017 Evan Peterson. All rights reserved.
//

import UIKit

class DictTableViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var allWords = [[String]]()
    var words = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadWords()

    }
    
    func searchBarButtonClicked(_ searchBar: UISearchBar) {
        guard let term = searchBar.text else { return }
        
        fuzzyCitySearch(term: term)
        
        tableView.reloadData()
    }
    
    func fuzzyCitySearch(term: String) {
        words = [[]]
        for word in allWords {
            let wordLetters: [Character] = (word.first?.lowercased().characters.flatMap { $0 })!
            let searchLetters: [Character] = term.lowercased().characters.flatMap ({ $0 })
            let wordSet = Set(wordLetters)
            let searchSet = Set(searchLetters)
            
            if searchSet.isSubset(of: wordSet) {
                words.append(word)
            }
        }
    }
    
    func loadWords() {
        guard let path = Bundle.main.path(forResource: "dictionary", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let dict = json as? [String:Any] else { return }
            for obj in dict {
                let objectDictionsry = [obj.key, "\(obj.value)"]
                self.allWords.append(objectDictionsry)
            }
            
        } catch {
            NSLog("error loading words")
        }
        words = allWords
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictCell", for: indexPath)
        
        let word = words[indexPath.row] as [String]
        cell.textLabel?.text = word.first
        cell.detailTextLabel?.text = word.last

        return cell
    }
}
