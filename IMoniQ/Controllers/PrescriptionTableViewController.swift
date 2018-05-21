//
//  PrescriptionTableViewController.swift
//  IMoniQ
//
//  Created by Zhaoqing Liu on 20/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit

class PrescriptionTableViewController: UITableViewController {
    
    // Being used to store model ranking list for table view's cell
    var prescriptions: [Prescription] = [
        Prescription(name: "Cold Treament", medicines: [Medicine(name: "Cephalexin Capsule 500mg", repeats: "1"), Medicine(name: "Salbutamol Sulfate Inhaler 100mcg/dose", repeats: "5")]),
        Prescription(name: "Treament for Rheumation", medicines: [Medicine(name: "Infliximab Powder of LV. Infusion 100mg", repeats: "2"), Medicine(name: "Pract MBBS", repeats: "2")])
    ];

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Prescription List";
        
        let backBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: nil);
        self.navigationItem.backBarButtonItem = backBarButtonItem;
//        self.navigationItem.leftBarButtonItem = ;
//        self.navigationItem.leftBarButtonItems = ;
        
//        let add: UIBarButtonItem = UIBarButtonItem.init(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addPrescription));
//        self.navigationItem.rightBarButtonItem = add;
    }
    
    @objc func addPrescription() {
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
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextView = segue.destination as? AddPrescriptionViewController {
            
            print(nextView.description);
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
