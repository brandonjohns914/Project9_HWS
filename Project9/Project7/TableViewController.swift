//
//  TableViewController.swift
//  Project7
//
//  Created by Brandon Johns on 4/26/23.
//

import UIKit

class TableViewController: UITableViewController {

    
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJson), with: nil) // json all in background thread

        
    }//view did load
    
    @objc func fetchJson()
    {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } // end if
        
        else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }//end else
        
            if let url = URL(string: urlString)
            {
                if let data = try? Data(contentsOf: url)
                {
                    parse(json: data)
                    return
                } // data
            } //url
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    
    } // fetchJson
    
   @objc func showError()
    {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }//showError
    
    func parse(json: Data)
    {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json)                                          // Petitions.self = petitions object making an instance
        {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false) // reloads data on main thread
        } // jsonPetitions
        else
        {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }// else
    }//parse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return petitions.count
    }// cell count
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
        
    }// cell
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view_controller = Detail_ViewController()
        view_controller.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(view_controller, animated: true)
    }// cell items

}
