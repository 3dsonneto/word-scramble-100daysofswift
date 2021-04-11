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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        //procura o arquivo start.txt no bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()

    }

    func startGame(){
        title = allWords.randomElement() //title do viewcontroller vai ser a palavra aleatoria
        usedWords.removeAll(keepingCapacity: true) //remove os valores do array de palavras usadas
        tableView.reloadData() //
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in //usa-se o weak pois o alertcontroller e o view controller estão sendo referenciados dentro do closure, então evita que eles sejam capturados de forma strong e ocuparem memoria por muito tempo. Podem não existir no futuro
                // antes do in são os parametros que vão entrar no closure, depois do in é o body do closure, o que vai acontecer depois do codigo ser rodado
            guard let answer = ac?.textFields?[0].text else { return } //no guard se tem alguma coisa ele vai rodar, se não tiver ele vai retornar
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        
    }
}

