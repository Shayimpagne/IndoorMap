//
//  CameraDetectionViewController.swift
//  IndoorMap
//
//  Created by Shayimpagne on 15/05/2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit
import CoreML
import Vision

class CameraDetectionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var imageTake:UIImageView!
    @IBOutlet var exhibitName:UILabel!
    @IBOutlet var showInMap:UIButton!
    var imagePicker:UIImagePickerController!
    var model:VNCoreMLModel!
    var currentExhibitName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exhibitName.text = ""
        self.showInMap.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(takePhoto))
        imageTake.addGestureRecognizer(tap)
        
        do {
            model = try VNCoreMLModel(for: artBelarusClassifier().model)
        } catch {
            print("can't create model")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageTake.contentMode = .scaleAspectFit
        imageTake.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.showInMap.isHidden = false
        
        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            self?.processClassifications(for: request, error: error)
        })
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: (imageTake.image?.cgImage)!, orientation: .up)
        do {
            try handler.perform([request])
        } catch {
            print("failed to get handler")
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            
            let classifications = results as! [VNClassificationObservation]
            self.exhibitName.text = "\(String(describing: (classifications.first?.identifier)!)) : \(String(describing: (classifications.first?.confidence)!))"
            self.currentExhibitName = String(describing: (classifications.first?.identifier)!)
            
            print(self.exhibitName.text!)
        }
    }
    
    @objc func takePhoto() {
        print("hey hey")
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPainting" && currentExhibitName != nil {
            let vc = segue.destination as! CameraMapViewController
            vc.currentExhibitName = self.currentExhibitName
        }
    }


}
