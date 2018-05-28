//
//  AddPrescriptionViewController.swift
//  IMoniQ
//
//  Created by Zhaoqing Liu on 21/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AddPrescriptionViewController: BasicViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    // For Firebase
    var ref: DatabaseReference!;
    var observerHandles: [DatabaseHandle] = [];
    
    @IBOutlet weak var txtPrescriptionName: UITextField!;
    @IBOutlet weak var txtMedicineName: UITextField!;
    // For UIPickerView for repeats of medicine
    let width: CGFloat = (UIScreen.main.bounds.size.width / 3.0);
    var repeats: Array<String> = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"];
    @IBOutlet weak var pickerRepeats: UIPickerView!
    var selectedPickerValue: String = "1";
    
    // For generating a unique key of a prescription, and it will be used by multiple medicines
    var newKey4Prescription: String!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Initialize global variables and interface
        // Instantiate this interface
        self.navigationItem.title = "Add Prescription";
        let backBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: nil);
        self.navigationItem.backBarButtonItem = backBarButtonItem; // Make the back button of the next view as default button
        
        txtPrescriptionName.delegate = self;
        txtMedicineName.delegate = self;
        // MARK: - Basic configuration for UIPickerView
        pickerRepeats.delegate = self;
        pickerRepeats.dataSource = self;
        pickerRepeats.selectRow(0, inComponent: 0, animated: true);
        
        // MARK: - Instantiate a object of connection to Firebase realtime database
        ref = Database.database().reference(); // Or: ref = Database.database(url: "https://imoniq-8ae5a.firebaseio.com").reference();
        
        newKey4Prescription = ref.child("prescriptions").childByAutoId().key;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        pickerRepeats.reloadAllComponents();
        
        for handle in observerHandles {
            ref.removeObserver(withHandle: handle);
        }
    }
    
    // MARK: - Releasing the Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    
    // MARK: - Operation for UIPickerView
    // When loading the UI, giving the number of columns of UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1;
    }
    
    // When loading the UI, giving the number of rows of each column of UIPickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if 0 == component {
            let count = self.repeats.count;
            return count;
        }
        return 0;
    }
    
    // When loading the UI, giving the width of each column of UIPickerView
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return width;
    }
    
    // When loading the UI, giving the height of each row of UIPickerView
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0;
    }
    
    // When loading the UI, giving the content shown in each row of UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if 0 == component {
            return repeats[row];
        }
        return nil;
    }
    
    // When loading the UI, giving the carbon content shown in each row of UIPickerView
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return nil;
    }
    
    // When loading the UI, giving the custom view shown in each row of UIPickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 40.0));
        label.textAlignment = NSTextAlignment.center;
        if 0 == component {
            label.text = repeats[row];
        }
        return label;
    }
    
    // When a row of UIPickerView is selected, set the value to display
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if 0 == component {
            selectedPickerValue = repeats[row];
        }
    }
    
    // MARK: - Operation for adding prescriptions
    @IBAction func addPrescription(_ sender: UIBarButtonItem) {
        
        if txtPrescriptionName.text == nil || txtPrescriptionName.text == "" {
            prompt("Please input the name of prescription.");
        } else if txtMedicineName.text == nil || txtMedicineName.text == "" {
            prompt("Please input the name of medicine.");
        } else {
            ref.child("prescriptions").child(newKey4Prescription!).setValue(["name": txtPrescriptionName.text!]);
            let subKey = ref.child("medicines").child(newKey4Prescription!).childByAutoId().key;
            ref.child("/medicines/\(newKey4Prescription!)/\(subKey)").setValue(["name": txtMedicineName.text!, "repeats": selectedPickerValue]);
            prompt("Prescription '\(txtPrescriptionName.text!)' is added successfully!")
            
            txtMedicineName.text = "";
            pickerRepeats.selectRow(0, inComponent: 0, animated: true);
            //self.navigationController?.popViewController(animated: true); // The second mode: go to the previous view
        }
    }
    
    @IBAction func clear(_ sender: UIBarButtonItem) {
        
        txtPrescriptionName.text = "";
        txtMedicineName.text = "";
        pickerRepeats.selectRow(0, inComponent: 0, animated: true);
    }
    
    
    // MARK: - Navigation - prepare data for next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextView = segue.destination as? AddImage4PrescriptionViewController {
            
            guard txtPrescriptionName.text != nil && !((txtPrescriptionName.text?.isEmpty)!)  else {
                
                prompt("Please input the name for prescription.")
                return;
            }
            nextView.name4PrescriptionImage = newKey4Prescription;
            print("$$$$$$$$$$$$$$$$$$$$$$ Name for Prescription Image: \(nextView.name4PrescriptionImage)");
        }
    }
    
}
