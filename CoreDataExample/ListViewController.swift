//
//  ListViewController.swift
//  CoreDataExample
//
//  Created by Priya Talreja on 04/06/17.
//  Copyright © 2017 Priya Talreja. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var data: [NSManagedObject] = []
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenBounds = UIScreen.main.bounds.size;
        let addButton = UIButton.init(frame: CGRect.init(x: screenBounds.width-70, y: screenBounds.height-70, width: 50, height: 50))
        addButton.backgroundColor = UIColor(red:0/255, green:64/255, blue:128/255, alpha:1.0)
        addButton.layer.cornerRadius = 50/2
        addButton.layer.masksToBounds = true
        addButton.setTitle("+", for: UIControlState.normal)
        addButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(addViewButton), for: UIControlEvents.touchUpInside);
        self.view.addSubview(addButton)
        
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    @IBAction func addViewButton(_ sender: AnyObject)
    {
        let addVc = self.storyboard?.instantiateViewController(withIdentifier: "AddDataViewController") as! AddDataViewController
        self.navigationController?.pushViewController(addVc, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    
    //Fetching Data
    func getData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInformation")
        do {
            data = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if(data.count == 0)
        {
            //If no data available show error
            noDataView.isHidden = false;
            tableView.isHidden = true;
        }
        else
        {
            noDataView.isHidden = true;
            tableView.isHidden = false;
            tableView.reloadData()

        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Tableview datasource and delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProfileTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)) as! ProfileTableViewCell
        
        let people = data[indexPath.row];
        let firstName = people.value(forKeyPath: "firstName") as? String
        let lastName = people.value(forKeyPath: "lastName") as? String
        let dob = people.value(forKeyPath: "dob") as? String
        cell.name.text! = firstName! + " " + lastName!
        cell.dob.text! = "Date of Birth:- " + dob!
        cell.city.text! = people.value(forKeyPath: "city") as! String
        let gender = people.value(forKeyPath: "isFemale") as! Bool
        if(gender)
        {
            cell.gender.image = UIImage(named:"female")
        }
        else
        {
             cell.gender.image = UIImage(named:"male")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVc = self.storyboard?.instantiateViewController(withIdentifier: "AddDataViewController") as! AddDataViewController
        addVc.data = data[indexPath.row]
        addVc.isDetailsView = true
        self.navigationController?.pushViewController(addVc, animated: true)
    }
    
}
