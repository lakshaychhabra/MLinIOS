//
//  ViewController.swift
//  HotdogML
//
//  Created by Lakshay Chhabra on 12/01/18.
//  Copyright © 2018 Lakshay Chhabra. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = userPickedimage
            guard let ciimage = CIImage(image: userPickedimage) else {
                fatalError("Failed to convert to CI image")
            }
            detectImage(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    func detectImage(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("ML model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError(" Failed to process image")
                
            }
            if let firstResults = results.first {
                if firstResults.identifier.contains("hotdog") {
                    self.navigationItem.title = "HOTDOG!!!!!"
                }
                else{
                    self.navigationItem.title = "NOT Hotdog!!!"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        }catch{
            print(error)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

