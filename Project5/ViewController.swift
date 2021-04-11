//
//  ViewController.swift
//  Project5
//
//  Created by Edson Neto on 11/04/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //procura o arquivo start.txt no bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }

    }

    func startGame(){
        title = allWords.randomElement() //title do viewcontroller vai ser a palavra
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

}

