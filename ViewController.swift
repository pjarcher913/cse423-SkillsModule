//
//  ViewController.swift
//  cse423f18_SkillsModuleProgram-Archer_Patrick
//
//  Created by Patrick Archer on 11/19/18.
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    // init ImagePickerController
    let picker = UIImagePickerController()
    var selectedImage:UIImage?
    
    // temp vars to store user data in RAM, rather than in CoreData (save function saves newest values of these vars to CoreData entity for their corresponding attributes)
    var tempName:String?
    var tempAge:Int16?
    var tempImageData:UIImage?

    //**************************************//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // configure picker delegate
        picker.delegate = self
        
        // set initial text of label_coreDataMsg
        self.label_coreDataMsg.text = "NOTE: Once your name and age have been saved, that data is stored non-volatily into your device's local CoreData file system."
        
        // fetch initial CoreData PersonEntity data
        self.fetchRecord()
        
        // call initial configurations
        self.refreshData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    //**************************************//
    
    // configure CoreData utilization
    
    // handler to the managege object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //this is the array to store location entities from the coredata
    var fetchResults = [PersonEntity]()
    
    func fetchRecord() -> Void {
        
        // Create a new fetch request using the LocationEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonEntity")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        //var x = 0
        
        // Execute the fetch request, and cast the results to an array of LocationEntity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [PersonEntity])!
        
        let x = fetchResults.count  // debug
        let y = fetchResults.description    //debug
        print("fetchResults.count = \(x)")    // debug
        print("fetchResults = \(y)")    // debug
        
    }
    
    //**************************************//
    
    // outlets for the two text fields in the UI
    @IBOutlet weak var textField_name: UITextField!
    @IBOutlet weak var textField_age: UITextField!
    
    @IBOutlet weak var label_coreDataMsg: UILabel!
    
    @IBOutlet weak var image_profilePic: UIImageView!
    
    // handles when user presses "Undo Unsaved" bar button
    @IBAction func barButton_revertPrev(_ sender: UIBarButtonItem) {
        // revert name, age, and image data back to most up to date SAVED data
        
        self.refreshData()
    }
    
    // handles when user presses "Edit Image" bar button
    @IBAction func barButton_editImage(_ sender: UIBarButtonItem) {
        // initiate image picker functionality and prompt user for what photo they would like
        
        print("\nNow executing changeImage func.\n")   // debug
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        
    }
    
    // handles when user presses "SAVE" button
    @IBAction func button_save(_ sender: UIButton) {
        // save current name, age, and image to CoreData
        
        // save current tempVar data to CoreData memory
        fetchResults[0].name = self.textField_name.text
        fetchResults[0].age = Int16((self.textField_age.text)!)!
        fetchResults[0].image = UIImagePNGRepresentation(self.image_profilePic.image!)! as NSData
        
    }
    
    /*==========================================================*/
    
    // delegate to control what happens when an image is selected from the library by the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker .dismiss(animated: true, completion: nil)
        
        let selectedImageAsUIImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.image_profilePic.image = selectedImageAsUIImage
        
    }
    
    // delegate to handle if the user presses cancel in the image picker view
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /*==========================================================*/

    // set displayed values/images within UI to whatever is currently stored in CoreData
    func refreshData() {
        
        // set values of temp vars by pulling stored PersonEntity data
        if fetchResults.count == 0 {
            tempName = ""
            tempAge = 0
            tempImageData = nil
        }else{
            tempName = fetchResults[0].name
            tempAge = fetchResults[0].age
            tempImageData = UIImage(data: fetchResults[0].image! as Data)
        }
        
        // set configurations of image_profilePic, textField_name, and textField_age
        self.image_profilePic.image = tempImageData
        self.textField_name.text = tempName
        self.textField_name.placeholder = tempName
        self.textField_age.text = String(tempAge!)
        self.textField_age.placeholder = String(tempAge!)
        
    }
    
}

