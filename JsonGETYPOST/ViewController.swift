//
//  ViewController.swift
//  JsonGETYPOST
//
//  Created by Ivan Miguel Chame Marroquin on 02/12/21.
//  Copyright © 2021 Ivan Miguel Chame Marroquin. All rights reserved.
//

import UIKit

struct User: Codable {
    let id : Int
    let name : String
    let email : String
    let address : Address
}

struct Address : Codable {
    let city : String
    let geo : String
    
}

struct Geo {
    let lat: String
    let lng: String
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tabla: UITableView!
    var usuarios = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJson()
    }
    
    func getJson() {
        guard let datos = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let url = URLRequest(url: datos)
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            do{
                self.usuarios = try JSONDecoder().decode([User].self, from: data!)
                DispatchQueue.main.async {
                    self.tabla.reloadData()
                }
                
            }catch let error as NSError {
                print("error en la api", error.localizedDescription)
                
            }
            
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = usuarios[indexPath.row]
        cell.textLabel?.text = user.address.geo
        cell.detailTextLabel?.text = user.address.city
        return cell
    }


    @IBAction func addPost(_ sender: UIBarButtonItem) {
        let parametros = ["username": "ivan", "email": "marro@hotmail.com"]
        guard let datos = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        var url = URLRequest(url: datos)
        url.httpMethod = "POST"
        url.addValue("application/json", forHTTPHeaderField: "Content-type")
        guard let body = try? JSONSerialization.data(withJSONObject: parametros, options: []) else { return }
        url.httpBody = body
        
        URLSession.shared.dataTask(with: url) { (data, respons, error) in }
    }
}

