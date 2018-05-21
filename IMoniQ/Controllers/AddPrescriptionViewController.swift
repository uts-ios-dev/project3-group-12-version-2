//
//  AddPrescriptionViewController.swift
//  IMoniQ
//
//  Created by Zhaoqing Liu on 21/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class AddPrescriptionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePickerController = UIImagePickerController();
    @IBOutlet weak var imgTaken: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Prescription";
        
        
        // - MARK: Basic configuration for UIImagePickerController
        imagePickerController.delegate = self;
        imagePickerController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal; // coverVertical; // crossDissolve; // partialCurl;
        imagePickerController.allowsEditing = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    /// Pop-up prompt window
    func prompt(_ message: String) {
        
        let sheet = UIAlertController.init(title: "Prompt Message", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        sheet.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
            
        }))
        self.present(sheet, animated: true, completion: nil)
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
    
}
