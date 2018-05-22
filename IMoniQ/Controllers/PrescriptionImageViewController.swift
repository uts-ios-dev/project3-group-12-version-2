//
//  PrescriptionImageViewController.swift
//  IMoniQ
//
//  Created by Zhaoqing Liu on 27/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import FirebaseStorage

class PrescriptionImageViewController: BasicViewController {
    
    var keyOfPrescription: String!
    var nameOfPrescription: String!
    var storageRef:StorageReference!;
    
    @IBOutlet weak var lblPrescriptionName: UILabel!
    @IBOutlet weak var progressViewOfDownloading: UIProgressView!
    @IBOutlet weak var imgPrescription: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Initialize global variables and interface
        // Instantiate this interface
        self.navigationItem.title = "Prescription Image";
        lblPrescriptionName.text = nameOfPrescription!;
        
        // - MARK: Basic configuration for uploading image
        progressViewOfDownloading.progress = 0; // The default percent of uploading process is zero
        progressViewOfDownloading.progressTintColor = UIColor.green;
        progressViewOfDownloading.trackTintColor = UIColor.blue;
        progressViewOfDownloading.transform = CGAffineTransform(scaleX: 1.0, y: 2.0);
        
        // MARK: - Instantiate a object of connection to Firebase Storage
        storageRef = Storage.storage().reference();
        
        downlaodImage();
    }
    
    // MARK: - Downloading image according the name of specified prescription
    @IBAction func downlaodImage() {
        
        let pRef = storageRef.child("prescriptions/\(keyOfPrescription!).jpg");
        let downloadTask = pRef.getData(maxSize: 100 * 1024 * 1024) { (data, error) in
            if error != nil {
                self.prompt("Download image failed.")
            } else {
                self.imgPrescription.image = UIImage(data: data!);
            }
        }
        
//        downloadTask.observe(.resume) { (snapshot) in
//            self.prompt("The downloading process is started.");
//        }
        downloadTask.observe(.pause) { (snapshot) in
            self.prompt("The downloading process is paused.");
        }
        downloadTask.observe(.progress) { (snapshot) in
            let percentComplete = 100.0 * Float(snapshot.progress!.completedUnitCount) / Float(snapshot.progress!.totalUnitCount);
            self.progressViewOfDownloading.setProgress(percentComplete, animated: true);
        }
        downloadTask.observe(.success) { (snapshot) in
            self.prompt("The downloading process is completed successfully.");
        }
        downloadTask.observe(.failure) { (snapshot) in
            guard let errorCode = (snapshot.error as NSError?)?.code else {
                return;
            }
            guard let error = StorageErrorCode(rawValue: errorCode) else {
                return;
            }
            switch (error) {
            case .projectNotFound:
                self.prompt("Project does not exist.");
                break;
            case .bucketNotFound:
                self.prompt("Bucket does not exist.");
                break;
            case .objectNotFound:
                self.prompt("File does not exist.");
                break;
            case .unauthorized:
                self.prompt("You don't have permission to access file.");
                break;
            case .cancelled:
                self.prompt("You cancelled the upload.")
                break;
            case .downloadSizeExceeded:
                self.prompt("The size of your image is exceeded the limitation.")
            case .unknown:
                self.prompt("Unknown error occurred, inspect the server response");
            default:
                self.downlaodImage();
                break;
            }
        }
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
