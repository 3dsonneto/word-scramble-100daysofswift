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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
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

    @objc func startGame(){
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
        let lowerAnswer = answer.lowercased() //deixa a palavra em minusculo
        
        if isPossible(word: lowerAnswer){ // verifica se é possível baseado na palavra
            if isOriginal(word: lowerAnswer){ // verifica se é original, não foi usada antes
                if isReal(word: lowerAnswer){ // verifica se é uma palavra existente, válida
                    usedWords.insert(lowerAnswer, at: 0) //insere no array de palavras usadas na posição 0
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic) //adiciona uma linha na row 0, section 0(no topo)
                    
                    return
                } else {
                    showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make them up, you know!")
                }
                
            } else {
                showErrorMessage(errorTitle: "Word already used", errorMessage: "Be more original!")
            }
        } else {
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title!.lowercased())." )
        }
        
       
    }
    
    
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word{ //loopa cada letra na palavra
            if let position = tempWord.firstIndex(of: letter){ //verifica se a letra faz parte da tempword(palavra no titulo)
                tempWord.remove(at: position) //se achar remove a letra da tempword e ela diminui(para não usarmos a mesma letra duas vezes)
            } else {
                return false //se não achar a letra retorna false
            }
        }
        return true //se achar todas a palavra é valida e retorna true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let tempWord = title
        
        if word.count < 3{
            return false
        }
        
        if tempWord == word {
            return false
        }
        
        
        let checker = UITextChecker() //não se da muito bem com Swift Strings, prefere objc strings(por isso o utf16.count)
        let range = NSRange(location: 0, length: word.utf16.count) //diz qual o alcance do scan, nesse caso do 0(inicio) até o fim da palavra
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")// qual palavra escanear, quanto da palavra vai ser escaneado
        return misspelledRange.location == NSNotFound// retorna o nsrange de onde o erro foi encontrado(se foi nsnotfound significa que não achou erro) nesse caso é true
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

