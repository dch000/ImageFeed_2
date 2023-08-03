import Foundation

extension Array {
    @discardableResult
        func replaceElement(oldElement: Int, withElement element: Photo) -> [Photo] {
        var photos = ImagesListService.shared.photos
        photos.replaceSubrange(oldElement...oldElement, with: [element])
        return photos
    }
}
