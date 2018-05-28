//
//  AddImage4PrescriptionViewController.swift
//  IMoniQ
//
//  Created by Zhaoqing Liu on 26/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import CoreGraphics
import AVKit
import MobileCoreServices
import FirebaseStorage
import SDWebImage

class AddImage4PrescriptionViewController: BasicViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    var name4PrescriptionImage: String!;
    var storageRef:StorageReference!;
    
    @IBOutlet weak var progressViewOfUploading: UIProgressView!
    
    // For UIImagePickerController for taken image
    let imagePickerController = UIImagePickerController();
    @IBOutlet weak var imgTaken: UIImageView!;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Initialize global variables and interface
        // Instantiate this interface
        self.navigationItem.title = "Upload Image";
        
        // - MARK: Basic configuration for UIImagePickerController
        imagePickerController.delegate = self;
        imagePickerController.modalTransitionStyle = UIModalTransitionStyle.coverVertical; // flipHorizontal; // crossDissolve; // partialCurl;
        imagePickerController.allowsEditing = true;
        
        // - MARK: Basic configuration for uploading image
        progressViewOfUploading.progress = 0; // The default percent of uploading process is zero
        progressViewOfUploading.progressTintColor = UIColor.green;
        progressViewOfUploading.trackTintColor = UIColor.blue;
        progressViewOfUploading.transform = CGAffineTransform(scaleX: 1.0, y: 2.0);
        
        // MARK: - Instantiate a object of connection to Firebase Storage
        storageRef = Storage.storage().reference();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Uploading the image of prescription to Firebase realtime database
    @IBAction func uploadImage() {
        
        if let imageOfPrescription = imgTaken.image {
            let data = UIImagePNGRepresentation(imageOfPrescription)!;
            let metadata = StorageMetadata();
            metadata.contentType = "image/jpeg";
            let pRef = storageRef.child("prescriptions/\(name4PrescriptionImage!).jpg");
            print("$$$$$$$$$$$$$$$$$ Full path: \(pRef.fullPath)");
            
            let uploadTask = pRef.putData(data, metadata: metadata);
            
//            uploadTask.observe(.resume) { (snapshot) in
//                self.prompt("The uploading process is started.");
//            }
            uploadTask.observe(.pause) { (snapshot) in
                self.prompt("The uploading process is paused.");
            }
            uploadTask.observe(.progress) { (snapshot) in
                let percentComplete = 100.0 * Float(snapshot.progress!.completedUnitCount) / Float(snapshot.progress!.totalUnitCount);
                self.progressViewOfUploading.setProgress(percentComplete, animated: true);
            }
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
                    self.uploadImage();
                    break;
                }
            }
        } else {
            prompt("Please choose a image for you prescription.")
        }
    }
    
    // MARK: - Operations for picking images
    @IBAction func getImageFromPhotosLibrary(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            self.present(imagePickerController, animated: true, completion: nil);
        } else {
            prompt("No available photo library.");
        }
    }
    
    @IBAction func takePhotoWithCamera(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let verificationResult = canAccessCamera();
            if (verificationResult.status) {
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera;
                imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo;
                self.present(imagePickerController, animated: true, completion: nil);
            } else {
                prompt(verificationResult.description);
            }
        } else {
            prompt("No available camera.");
        }
    }
    
    /// If have the authorization for accessing camera.
    /// * The verification results depend on the system settings of the user's device.
    func canAccessCamera() -> (status: Bool, description: String) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        if (status == .denied) {
            return (false, "You denied access to the camera, so this feature will not be available.");
        } else if (status == .restricted) {
            return (false, "You have set restriction on the access to the camera. Please set up the app to allow access to the camera.");
        }
        return (true, "Accessible");
    }
    
    /// Callback function for invoking camera. Execute iamge processing mode.
    /// * picker: The object which pick the image
    /// - info: An array of the images user chose or of the pictures user took
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if imagePickerController.mediaTypes == [kUTTypeImage as String] {
            imgTaken.image = (info[UIImagePickerControllerEditedImage] as! UIImage);
            // Parse image to text content and store into database
            // parse code .....................................................................
            // persistent code ................................................................
        }
        self.dismiss(animated: true, completion: nil);
    }
    

    // MARK: - Navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
     */

}
