import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var singleImageURL: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        didTap()
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let share  = UIActivityViewController(activityItems: [image as Any],
                                              applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func didTap() {
        dismiss(animated: true, completion: nil)
    }
    
    private func rescaleAndeCenterImageScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width
        let vScale = visibleRectSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func singleImageLoad() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: singleImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndeCenterImageScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alertController = UIAlertController(title: "Что-то пошло не так",
                                                message: "Попробуйте еще раз",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .default))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] result in
            guard let self = self else { return }
            self.singleImageLoad()
        }))
        present(alertController, animated: true)
    }
}

//+
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
