//
//  InfoViewController.swift
//  RockAnalyzer
//
//  Created by Colby Janecka on 11/30/21.
//


import UIKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        predictionLabel.text = text
        imageView?.image = photoToPredict
        makePredictions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var photoToPredict: UIImage!

    /// A predictor instance that uses Vision and Core ML to generate prediction strings from a photo.
    let imagePredictor = ImagePredictor()

    /// The largest number of predictions the main view controller displays the user.
    let predictionsToShow = 2

    // MARK: Main storyboard outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var rockInfoLabel: UILabel!
    
    var text:String = ""
}

extension InfoViewController {
    // MARK: Main storyboard updates
    /// Updates the storyboard's image view.
    /// - Parameter image: An image.
    func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    
    func makePredictions() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.classifyImage(self.photoToPredict)
        }
    }
    
    /// Updates the storyboard's prediction label.
    /// - Parameter message: A prediction or message string.
    /// - Tag: updatePredictionLabel
    func updatePredictionLabel(_ message: String) {
        DispatchQueue.main.async {
            self.predictionLabel.text = message
        }
    }
    
    /// Updates the storyboard's accuracy label.
    /// - Parameter message: A prediction or message string.
    /// - Tag: updateAccuracyLabel
    func updateAccuracyLabel(_ message: String) {
        DispatchQueue.main.async {
            self.accuracyLabel.text = message
        }
    }
    
    
    /// Updates the storyboard's rock information label.
    /// - Parameter message: A prediction or message string.
    /// - Tag: updatePredictionLabel
    func updateRockInfo(_ rock: String) {
        DispatchQueue.main.async {
            var message: String
            if(rock == "Limestone"){
                message = "Recommend not using cams unless absolutely necessary.  It is safer to stick to sport climbing when it comes to this rock."
            } else if (rock == "Granite"){
                message = "Watch out for polished faces that don't hold cams well!"
            } else if (rock == "Sandstone"){
                message = "Absolutely do NOT climb on this rock in any type of percipitation! It will crumble."
            } else if (rock == "Quartzite"){
                message = "Be carful of sharp edges that will easily cut you!"
            } else {
                message = "No special info about this rock!"
            }
            self.rockInfoLabel.text = message
            self.rockInfoLabel.isHidden = false
        }
    }
}

extension InfoViewController {
    // MARK: Image prediction methods
    /// Sends a photo to the Image Predictor to get a prediction of its content.
    /// - Parameter image: A photo.
    private func classifyImage(_ image: UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }

    /// The method the Image Predictor calls when its image classifier model generates a prediction.
    /// - Parameter predictions: An array of predictions.
    /// - Tag: imagePredictionHandler
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            updatePredictionLabel("No predictions. (Check console log.)")
            return
        }

        let predArray = formatPredictions(predictions)
        let (formattedPrediction, formattedAccuracy) = predArray[0]

        let predictionString = formattedPrediction
        let accuracyString = formattedAccuracy
        updatePredictionLabel(predictionString)
        updateAccuracyLabel(accuracyString)
        
        updateRockInfo(predictionString)

        
    }

    /// Converts a prediction's observations into human-readable strings.
    /// - Parameter observations: The classification observations from a Vision request.
    /// - Tag: formatPredictions
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [(String, String)] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [(String, String)] = predictions.prefix(predictionsToShow).map { prediction in
            let name = prediction.classification

            return ("\(name)", "\(prediction.confidencePercentage)%")
        }

        return topPredictions
    }
}
