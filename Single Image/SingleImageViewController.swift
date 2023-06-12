import UIKit

final class SingleImageViewController : UIViewController {
    var image:  UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
