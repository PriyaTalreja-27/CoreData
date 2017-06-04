//
//  AddDataViewController.swift
//  CoreDataExample
//
//  Created by Priya Talreja on 04/06/17.
//  Copyright © 2017 Priya Talreja. All rights reserved.
//

import UIKit
import CoreData

class AddDataViewController: UIViewController,UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    var data: NSManagedObject = NSManagedObject()
    var isDetailsView: Bool = Bool()
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var dob: SkyFloatingLabelTextField!
    @IBOutlet weak var city: SkyFloatingLabelTextField!
    @IBOutlet weak var lastName: SkyFloatingLabelTextField!
    @IBOutlet weak var firstName: SkyFloatingLabelTextField!
    var activetextfield:SkyFloatingLabelTextField!
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        deleteData()
    }
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func saveButtonClicked(_ sender: Any) {
        if isDetailsView {
            editData()
        }
        else
        {
            saveData()
        }
        
    }
    
    
    @IBAction func editClicked(_ sender: Any) {
        titleText.text = "Edit/ Delete"
        firstName.isUserInteractionEnabled = true;
        lastName.isUserInteractionEnabled = true;
        dob.isUserInteractionEnabled = true;
        genderSwitch.isUserInteractionEnabled = true;
        city.isUserInteractionEnabled = true;
        buttonLabel.isHidden = false;
        deleteLabel.isHidden = false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isDetailsView {
            
            titleText.text = "Details"
            firstName.isUserInteractionEnabled = false;
            lastName.isUserInteractionEnabled = false;
            dob.isUserInteractionEnabled = false;
            genderSwitch.isUserInteractionEnabled = false;
            city.isUserInteractionEnabled = false;
            buttonLabel.text = "Update"
            buttonLabel.isHidden = true;
            editImage.isHidden = false;
            deleteLabel.isHidden = true;
            firstName.text! = data.value(forKeyPath: "firstName") as! String
            lastName.text! = data.value(forKeyPath: "lastName") as! String
            dob.text! = data.value(forKeyPath: "dob") as! String
            city.text! = data.value(forKeyPath: "city") as! String
            let gender = data.value(forKeyPath: "isFemale") as! Bool
            genderSwitch.isOn = gender;
        }
        else
        {
            editImage.isHidden = true;
            deleteLabel.isHidden = true;
        }
        
    }
    func saveData()
    {
        guard let appDel:AppDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let profileInfoEntity = NSEntityDescription.entity(forEntityName: "ProfileInformation",in: managedContext)!
        let info = NSManagedObject(entity:profileInfoEntity,
                                   insertInto:managedContext);
        info.setValue(firstName.text!, forKey: "firstName")
        info.setValue(lastName.text!, forKey: "lastName")
        info.setValue(city.text!, forKey: "city")
        info.setValue(dob.text!, forKey: "dob")
        info.setValue(genderSwitch.isOn, forKey: "isFemale")
        info.setValue(String.random(), forKey: "userId")
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        
    }
    func editData()
    {
        guard let appDel:AppDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        
        data.setValue(firstName.text!, forKey: "firstName")
        data.setValue(lastName.text!, forKey: "lastName")
        data.setValue(city.text!, forKey: "city")
        data.setValue(dob.text!, forKey: "dob")
        data.setValue(genderSwitch.isOn, forKey: "isFemale")
        
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            
            
        }
        
        
        
    }
    
    func deleteData()
    {
        guard let appDel:AppDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDel.persistentContainer.viewContext
        managedContext.delete(data)
        
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activetextfield = textField as! SkyFloatingLabelTextField
        if textField.tag == 10 {
            let datePickerView:UIDatePicker = UIDatePicker()
            
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            textField.inputView = datePickerView
            let toolBar = UIToolbar().ToolbarPiker(#selector(AddDataViewController.dismissPicker))
            
            textField.inputAccessoryView = toolBar
            datePickerView.addTarget(self, action: #selector(AddDataViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        
    }
    //MARK: - DatePicker methods
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dob.text = dateFormatter.string(from: sender.date)
        
    }
    
    func dismissPicker() {
        
        view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - KeyBoard methods
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(AddDataViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddDataViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func keyboardWasShown(_ aNotification: Notification) {
        
        var info: [AnyHashable: Any] = (aNotification as NSNotification).userInfo!
        
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        
        if !aRect.contains(activetextfield.frame.origin) {
            self.scrollView.scrollRectToVisible(activetextfield.frame, animated: true)
        }
        
    }
    func keyboardWillBeHidden(_ aNotification: Notification) {
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
