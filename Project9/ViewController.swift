//
//  ViewController.swift
//  Project7
//
//  Created by Hafizh Caesandro Kevinoza on 06/04/22.
//

import UIKit

class ViewController: UITableViewController {
    
    // variable yang akan menampung nilai petition
    var petitions = [Petition]()
    
//    var allPetitions = [Petition]()
//    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // create variable urlString
        let urlString: String
        
        title = "White House Petition"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(promptCredit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promptFilter))
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        // Using Async() to do multithread
        // DispatchQueue = An object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.
        // global = Returns the global system queue with the specified quality-of-service class.
        DispatchQueue.global(qos: .userInitiated).async {
            // URL() = A value that identifies the location of a resource, such as an item on a remote server or the path to a local file.
            // this condition to unwrap optional urlString
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            self.showError()
        }
    }
    
    // MARK: OBJC
    @objc func promptCredit () {
        let cc = UIAlertController(title: "Credit", message: "Data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        cc.reloadInputViews()
        
        cc.addAction(UIAlertAction(title: "Ok", style: .default))
        //        cc.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        
        present(cc, animated: true)
    }
    
    @objc func promptFilter() {
        let ac = UIAlertController(title: "Enter keyword", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer: answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func submit(answer: String) {
//        allPetitions += petitions
//        for item in allPetitions {
//            if item.title.lowercased().contains("\(answer.lowercased())") {
//                filteredPetitions.append(item)
//
//                // I searched through the array for items containing
//                //the inserted string in the title. I used the lowercased
//                //method to avoid loosing some items due to the case
//                //sensitive criteria
//
//            }
//
//        }
//
//        // I cleared the array that is shown in the table view, and added
//        //the found items there. I used a for loop, but as i said, i think that
//        //roosterboy's solution should be more efficient.
//
//        petitions.removeAll(keepingCapacity: true)
//        petitions += filteredPetitions
//        tableView.reloadData()
    }
    
    // MARK: Normal
    // Data = A byte buffer in memory.
    func parse(json: Data) {
        // JSONDecoder = An object that decodes instances of a data type from JSON objects.
        let decoder = JSONDecoder()
        
        // try = check if it work
        // decode(...) = Returns a value of the type you specify, decoded from a JSON object.
        if let jsonPetitions = try?  decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            // reloadData() = Reloads the rows and sections of the table view.
            // DispactQueue
            // .main = The dispatch queue associated with the main thread of the current process.
            if let jsonPetitions = try?  decoder.decode(Petitions.self, from: json) {
                petitions = jsonPetitions.results
                // execute code on main thread
                DispatchQueue.main.async {
                    // reloadData() = Reloads the rows and sections of the table view.
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Table
    // Menghitung jumlah baris yang dapat ditemukan
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        // count = The number of elements in the array.
        return petitions.count
    }
    
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueReusableCell = Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        // textLabel = The label to use for the main textual content of the table cell.
        // text = The text that the label displays.
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        // return cell value
        return cell
    }
    
    // Action related selected row on table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        print("\(petitions[indexPath.row])")
        // pushViewController(...) = Pushes a view controller onto the receiver’s stack and updates the display.
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Error
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}

