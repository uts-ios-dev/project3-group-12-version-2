//
//  PrescriptionTableViewController.swift
//  IMoniQ
//
//  Created by Zhaoqing Liu on 20/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class PrescriptionTableViewController: BasicTableViewController
{
    
    var ref: DatabaseReference!;
    var observerHandles: [DatabaseHandle] = [];
    
    // For testing data into Firebase
    var prescriptions: [Prescription] = [];
    
    var storageRef:StorageReference!;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Initialize global variables and interface
        // Instantiate this interface
        self.navigationItem.title = "Prescription List";
        let backBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: nil);
        self.navigationItem.backBarButtonItem = backBarButtonItem; // Make the back button of the next view as default button
        
        // Instantiate a object of connection to Firebase realtime database
        ref = Database.database().reference(); // Or: ref = Database.database(url: "https://imoniq-8ae5a.firebaseio.com").reference();
        
        // Observe the any change of the database by a listener
        ref.observe(DataEventType.value) { (snapshot) in
            self.reloadPrescriptions(snapshot);
        }
        storageRef = Storage.storage().reference();
    }
    
    /// Loading all the prescriptions which belongs to the current user to the data source of the prescription table view
    func loadPrescriptions(_ snapshot: DataSnapshot) {

        let loadedPrescriptions = snapshot.childSnapshot(forPath: "prescriptions").children;
        for prescription in loadedPrescriptions {
            let key = (prescription as! DataSnapshot).key;
            let name = (prescription as! DataSnapshot).childSnapshot(forPath: "name").value;
            var newPrescription = Prescription(key: key, name: name as! String, medicines: []);
            
            let loadedMedicines = snapshot.childSnapshot(forPath: "medicines").children;
            for prescriptionRef in loadedMedicines {
                //print("***************** \((prescription as! DataSnapshot).key.elementsEqual((prescriptionRef as! DataSnapshot).key))");
                if ((prescriptionRef as! DataSnapshot).key.elementsEqual((prescription as! DataSnapshot).key)) {
                    
                    let loadedMedicines = (prescriptionRef as! DataSnapshot).children;
                    for medicine in loadedMedicines {
                        let key = (medicine as! DataSnapshot).key;
                        let name = (medicine as! DataSnapshot).childSnapshot(forPath: "name").value;
                        let repeats = (medicine as! DataSnapshot).childSnapshot(forPath: "repeats").value;
                        let newMedicine = Medicine(key: key, name: name as! String, repeats: repeats as! String);
                        newPrescription.medicines.append(newMedicine);
                    }
                }
            }
            
            self.prescriptions.append(newPrescription);
        }
    }
    
    /// Reloading all the prescriptions which belongs to the current user to the data source of the prescription table view
    func reloadPrescriptions(_ snapshot: DataSnapshot) {
        
        prescriptions = [];
        loadPrescriptions(snapshot);
        self.tableView.reloadData();
    }
    
    @IBAction func initializePrescriptionSamples(_ sender: UIBarButtonItem) {
        
        let key1 = ref.child("prescriptions").childByAutoId().key;
        ref.child("prescriptions").child(key1).setValue(["name": "Cold Treament"]);
        let key11 = ref.child("medicines").child(key1).childByAutoId().key;
        let key12 = ref.child("medicines").child(key1).childByAutoId().key;
        ref.child("/medicines/\(key1)/\(key11)").setValue(["name": "Cephalexin Capsule 500mg", "repeats": "1"]);
        ref.child("/medicines/\(key1)/\(key12)").setValue(["name": "Salbutamol Sulfate Inhaler 100mcg/dose", "repeats": "5"]);
        
        let key2 = ref.child("prescriptions").childByAutoId().key;
        ref.child("prescriptions").child(key2).setValue(["name": "Cold Treament"]);
        let key21 = ref.child("medicines").child(key2).childByAutoId().key;
        let key22 = ref.child("medicines").child(key2).childByAutoId().key;
        ref.child("/medicines/\(key2)/\(key21)").setValue(["name": "Infliximab Powder of LV. Infusion 100mg", "repeats": "2"]);
        ref.child("/medicines/\(key2)/\(key22)").setValue(["name": "Pract MBBS", "repeats": "2"]);
        
        let key3 = ref.child("prescriptions").childByAutoId().key;
        ref.child("prescriptions").child(key3).setValue(["name": "Gastrointestinal Agent"]);
        let key31 = ref.child("medicines").child(key3).childByAutoId().key;
        let key32 = ref.child("medicines").child(key3).childByAutoId().key;
        let key33 = ref.child("medicines").child(key3).childByAutoId().key;
        let key34 = ref.child("medicines").child(key3).childByAutoId().key;
        ref.child("/medicines/\(key3)/\(key31)").setValue(["name": "Diavlproex (Depakote ER) 500mg", "repeats": "1"]);
        ref.child("/medicines/\(key3)/\(key32)").setValue(["name": "5-Aminosalicylates", "repeats": "5"]);
        ref.child("/medicines/\(key3)/\(key33)").setValue(["name": "GI Stimulants", "repeats": "1"]);
        ref.child("/medicines/\(key3)/\(key34)").setValue(["name": "Proton Pump Inhibitors", "repeats": "2"]);
        
        let key4 = ref.child("prescriptions").childByAutoId().key;
        ref.child("prescriptions").child(key4).setValue(["name": "Mental Anxiety Disorder"]);
        let key41 = ref.child("medicines").child(key4).childByAutoId().key;
        let key42 = ref.child("medicines").child(key4).childByAutoId().key;
        let key43 = ref.child("medicines").child(key4).childByAutoId().key;
        let key44 = ref.child("medicines").child(key4).childByAutoId().key;
        let key45 = ref.child("medicines").child(key4).childByAutoId().key;
        ref.child("/medicines/\(key4)/\(key41)").setValue(["name": "Don't Get Angry", "repeats": "24"]);
        ref.child("/medicines/\(key4)/\(key42)").setValue(["name": "Don't Worry", "repeats": "24"]);
        ref.child("/medicines/\(key4)/\(key43)").setValue(["name": "Be Grateful", "repeats": "24"]);
        ref.child("/medicines/\(key4)/\(key44)").setValue(["name": "Work Hard", "repeats": "24"]);
        ref.child("/medicines/\(key4)/\(key45)").setValue(["name": "Be Kind to Others", "repeats": "24"]);
        
        // Initialize images for prescriptions
        let pImages = [key1: UIImage(named: "prescription1.jpg"), key2: UIImage(named: "prescription2.jpg"), key3: UIImage(named: "prescription3.jpg"), key4: UIImage(named: "prescription4.jpg")];
        for (key, value) in pImages {
            print("**************** \(key)")
            let data = UIImagePNGRepresentation(value!);
            let metadata = StorageMetadata();
            metadata.contentType = "image/jpeg";
            let pRef = storageRef.child("prescriptions/\(key).jpg");
            let uploadTask = pRef.putData(data!, metadata: metadata);
            uploadTask.observe(.success) { (snapshot) in
                self.prompt("The uploading process is completed successfully.");
            }
            uploadTask.observe(.failure) { (snapshot) in
                guard let errorCode = (snapshot.error as NSError?)?.code else {
                    return;
                }
                guard let error = StorageErrorCode(rawValue: errorCode) else {
                    return;
                }
                switch (error) {
                case .bucketNotFound:
                    self.prompt("Bucket does not exist.");
                    break;
                case .unauthorized:
                    self.prompt("You don't have permission to access file.");
                    break;
                default:
                    self.prompt("Unknown error occurred, inspect the server response");
                    break;
                }
            }
        }
    }
    
    @IBAction func emptyPrescriptions(_ sender: UIBarButtonItem) {
        
        ref.removeValue();
        for p in prescriptions {
            print("*************** Key to be deleted: \(p.key)")
            storageRef.child("prescriptions/\(p.key).jpg").delete { (error) in
                if let err = error {
                    self.prompt("Delete all prescriptions' image failed! An error occured: \(err.localizedDescription)")
                } else {
                    self.prompt("Delete all prescriptions' image successfully!");
                }
            }
        }
        self.tableView.reloadData();
    }
    
    @objc func addPrescription() {
        
        // Show the view for adding a prescription
        let addPrescriptionView = AddPrescriptionViewController();
        self.navigationController?.pushViewController(addPrescriptionView, animated: true);
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return prescriptions.count;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return prescriptions[section].medicines.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        var cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell");
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "medicineCell");
        }
        let prescription = prescriptions[indexPath.section];
        let medicine = prescription.medicines[indexPath.row];
        cell?.textLabel?.text = medicine.name;
        cell?.detailTextLabel?.text = medicine.repeats;

        return cell!;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return prescriptions[section].name;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pImageViewController = self.storyboard?.instantiateViewController(withIdentifier: "pImageViewController") as! PrescriptionImageViewController;
        pImageViewController.keyOfPrescription = prescriptions[indexPath.section].key;
        pImageViewController.nameOfPrescription = prescriptions[indexPath.section].name;
        print("$$$$$$$$$$$$$$$$$ Key : \(pImageViewController.keyOfPrescription), Prescription Name: \(String(describing: pImageViewController.nameOfPrescription))");
        self.navigationController?.pushViewController(pImageViewController, animated: true);
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // do not allow the specified item to be editable
        return true;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("************** Section index: \(indexPath.section) | Cell index: \(indexPath.row)");
            
            let keyOfPrescription = prescriptions[indexPath.section].key;
            let keyOfMedicine = prescriptions[indexPath.section].medicines[indexPath.row].key;
            
            // Step 1: Delete the record from the Firebase database
            deleteMedecine(by: keyOfPrescription, and: keyOfMedicine);
            
            // Step 2: Delete the corresponding record from the data source of table view (must to do!)
            prescriptions[indexPath.section].medicines.remove(at: indexPath.row);
            
            // Step 3: If the prescription, which is the deleted medicine belongs to, doesn't have any medicine, also delete it
            // Note: If zero row in a section, don't perform the method 'deleteRows', which will cause exeption like 'set height of a row, but there is not any row'. In this situation, but perform the method 'deleteSections'
            if prescriptions[indexPath.section].medicines.count > 0 {
                // Delete the row from the section of the table view
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic);
            } else {
                deletePrescription(by: prescriptions[indexPath.section].key);
                prescriptions.remove(at: indexPath.section);
                tableView.deleteSections([indexPath.section], with: UITableViewRowAnimation.automatic);
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
    }
    */

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Do not allow the item to be re-orderable
        return false;
    }
    
    func deleteMedecine(by keyOfPrescription: String, and keyOfMedicine: String) {
        print("&&&&&&&&&&&&&& Delete medicine | Prescription Key: \(keyOfPrescription) | Medicine Key: \(keyOfMedicine)");
        let mRef = ref.child("medicines").child(keyOfPrescription).child(keyOfMedicine);
        mRef.removeValue();
    }
    
    func deletePrescription(by key: String) {
        print("&&&&&&&&&&&&&& Delete prescription | Prescription Key: \(key)")
        let pRef = ref.child("prescriptions").child(key);
        pRef.removeValue();
        
        deletePrescriptionImage(by: key);
    }
    
    func deletePrescriptionImage(by key: String) {
        
        let pRef = storageRef.child("prescriptions/\(key).jpg");
        pRef.delete { (error) in
            if let err = error {
                self.prompt("Delete prescription's image failed! An error occured: \(err.localizedDescription)")
            } else {
                self.prompt("Delete prescription's image successfully!");
            }
        }
    }

    
    // MARK: - Navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextView = segue.destination as? AddPrescriptionViewController {
        }
    }
     */

}
