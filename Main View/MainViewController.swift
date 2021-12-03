/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The view controller that selects an image and makes a prediction using Vision and Core ML.
*/

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        self.performSegue(withIdentifier: "ToWelcomeView", sender: self)
    }
    /// The largest number of predictions the main view controller displays the user.
    let predictionsToShow = 2
    
    var photoToPredict: UIImage!

    // MARK: Main storyboard outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
}

extension MainViewController {


    /// The method the storyboard calls when the user taps the pick photo button.
    @IBAction func pickPhotoButton(sender: UIButton!) {
        present(photoPicker, animated: true)
    }
    
    @IBAction func takePhotoButton(sender: UIButton!) {
        present(cameraPicker, animated: true)
    }
    
    @IBAction func predictPhotoButton(sender: Any) {
        
        if photoToPredict != nil {
            self.performSegue(withIdentifier: "ToInfoView", sender: self)
        } else {
            self.warningLabel.text = "Please Select an Image to Predict"
            self.warningLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.warningLabel.isHidden = true
        if segue.identifier == "ToInfoView",
           let nextViewController = segue.destination as? InfoViewController {
            nextViewController.photoToPredict = self.imageView.image
            nextViewController.text = "Predicting..."
        }
    }
}

extension MainViewController {
    // MARK: Main storyboard updates
    /// Updates the storyboard's image view.
    /// - Parameter image: An image.
    func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.photoToPredict = image
        }
    }

    /// Notifies the view controller when a user selects a photo in the camera picker or photo library picker.
    /// - Parameter photo: A photo from the camera or photo library.
    func userSelectedPhoto(_ photo: UIImage) {
        updateImage(photo)
        photoToPredict = photo
    }
}
