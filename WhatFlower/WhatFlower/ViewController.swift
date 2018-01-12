//
//  ViewController.swift
//  WhatFlower
//
//  Created by Lakshay Chhabra on 12/01/18.
//  Copyright © 2018 Lakshay Chhabra. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var label: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    
    let imagePicker = UIImagePickerController()

    
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
       
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
        
            guard let convertedCiImage = CIImage(image: userPickedImage) else {
            fatalError("Cant convert to CI IMage")
        }
        
        
            detectImage(image: convertedCiImage)
        
        }
        
        //after picking the image to dismiss the popped up gallery
         imagePicker.dismiss(animated: true, completion: nil)
        
        
    }

    func detectImage(image: CIImage){
        
        //see the class from FLowerclassifer.mlmodel
        
       guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else{
            fatalError("Cant Load the machine learning Module")
            
        }
        //Now we gonna create a request
        let request = VNCoreMLRequest(model: model) { (request, error) in
       
            guard let classification = request.results?.first as? VNClassificationObservation else{
                fatalError("cant find the image")
            }
            
           
            
            self.navigationItem.title = classification.identifier.capitalized
            self.requestInfo(flowerName: classification.identifier)
        }
        
        
        //handler to process that request
        
        let handler = VNImageRequestHandler(ciImage: image)
    do  {
            try handler.perform([request])
        }
    catch {
            print(error)
        }
        
    }
    
    
    func requestInfo(flowerName: String)
    {
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerName,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize":"500"
            ]

        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Got the Wiki Info")
                print(response)
                
                let flowerJson = JSON(response.result.value!)
                let pageId = flowerJson["query"]["pageids"][0].stringValue
                
                let flowerDesciption = flowerJson["query"]["pages"][pageId]["extract"].stringValue
             
                let flowerImageURL = flowerJson["query"]["pages"][pageId]["thumbnail"]["source"].stringValue
                
                self.imageView.sd_setImage(with: URL(string: flowerImageURL))
                
                self.label.text = flowerDesciption
              
                
                
            }
        }
    }
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        //for popping up the gallery
        
        present(imagePicker, animated: true, completion: nil)
        
       
        
        
        
    }
    
}

