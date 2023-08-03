import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var dateCell: UILabel!
    
    @IBOutlet weak var likeCell: UIButton!
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "active_photo") : UIImage(named: "no_active_photo")
        likeCell.setImage(likeImage, for: .normal)
    }
    
}
