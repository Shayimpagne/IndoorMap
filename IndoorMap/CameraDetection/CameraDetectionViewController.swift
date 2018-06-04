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
    @IBOutlet weak var imageTake:UIImageView!
    @IBOutlet var exhibitName:UILabel!
    var imagePicker:UIImagePickerController!
    var model:VNCoreMLModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            model = try VNCoreMLModel(for: PaintingsClassifier().model)
        } catch {
            print("can't create model")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageTake.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
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
            
//            if (classifications.first?.confidence.isLess(than: 50.0))! {
//                let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraMap") as! CameraMapViewController
//                cameraVC.location = (300, 400)
//                self.present(cameraVC, animated: true)
//            }
            
            print(self.exhibitName.text!)
        }
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

}
