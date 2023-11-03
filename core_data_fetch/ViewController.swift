//
//  ViewController.swift
//  core_data_fetch
//
//  Created by Admin on 29/08/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var FetchData:[NSManagedObject] = []
    
    @IBOutlet weak var savebutton: UIButton!
    
    
    @IBOutlet weak var textfield2: UITextField!
    @IBOutlet weak var textfield1: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchdata()
        
    }
    
    
    @IBAction func savebutton(_ sender: Any) {
        
        
        let managecontext = appdelegate.persistentContainer.viewContext
        
        if let indexPath = tableview.indexPathForSelectedRow {
            
            let selectedData = FetchData[indexPath.row]
            
            selectedData.setValue(textfield1.text ?? "", forKey: "employename")
            selectedData.setValue(textfield2.text ?? "", forKey: "emoploye_id")
            
            do {
                try managecontext.save()
                print("Data updated successfully")
                fetchdata()
            } catch {
                print("Error updating data: \(error)")
            }
        } else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: managecontext)
            let record = NSManagedObject(entity: entity!, insertInto: managecontext)
            record.setValue(textfield1.text ?? "", forKey: "employename")
            record.setValue(textfield2.text ?? "", forKey: "emoploye_id")
            
            do {
                try managecontext.save()
                print("Data saved successfully")
                fetchdata()
            } catch {
                print("Error saving data: \(error)")
            }
        }
        
        
        textfield1.text = ""
        textfield2.text = ""
    }
    
    
    func fetchdata() {
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let managecontext = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        
        do{
            let result = try managecontext.fetch(request)
            FetchData = result as! [NSManagedObject]
            
            tableview.reloadData()
            
        }
        catch
        {
            print("Error fetching data: \(error)")
        }
        
        
    }
    
    func updatedata() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        request.predicate = NSPredicate(format: "employename = %@", textfield1.text!)
        
        do {
            let data = try context.fetch(request)
            
            if let obj = data.first as? NSManagedObject {
                obj.setValue(textfield1.text, forKey: "employename")
                obj.setValue(textfield2.text, forKey: "emoploye_id")
                
                
                do {
                    try context.save()
                    print("Data updated successfully")
                } catch {
                    print("Error saving data: \(error)")
                }
            } else {
                print("No matching data found for employename: \(textfield1.text ?? "")")
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let user = FetchData[indexPath.row]
            context.delete(user)
            do{
                try context.save()
                fetchdata()
                print("delete")
            }
            catch{
                
                print("error")
            }
        }
        
    }
    
}





extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FetchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)as! TableViewCell
        let data = FetchData[indexPath.row]
        cell.label.text = data.value(forKey: "employename")as? String
        cell.label2.text = data.value(forKey: "emoploye_id")as? String
        
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}








