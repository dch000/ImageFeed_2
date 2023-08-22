import UIKit

public protocol ImagesListServiceProtocol: AnyObject {
    func fetchPhotosNextPage()
}

final class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private let perPage = "10"
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let dateFormater = ISO8601DateFormatter()
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1: lastLoadedPage! + 1
        guard let token = OAuth2TokenStorage.token else { return }
        guard let request = fetchImageListRequest(token,
                                                  page: String(nextPage),
                                                  perPage: perPage
        ) else { return }
        let task = URLSession.shared.object(for: request ) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.task = nil
                switch result {
                case .success(let photosResults):
                    photosResults.forEach { image in
                        let date = self.dateFormater.date(from: image.createdAt ?? "")
                        guard let thumbImage = image.urls?.thumbImageURL,
                              let fullImage = image.urls?.largeImageURL else { return }
                        self.photos.append(Photo(id: image.id,
                                                 size: CGSize(width: image.width ?? 0, height: image.height ?? 0),
                                                 createdAt: date,
                                                 welcomeDescription: image.welcomeDescription,
                                                 thumbImageURL: thumbImage,
                                                 largeImageURL: fullImage,
                                                 isLiked: image.isLiked ?? false))
                        print(self.photos)
                    }
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["Images": self.photos])
                    self.lastLoadedPage = nextPage
                case .failure(let error):
                    assertionFailure("Не удалось получить изображение \(error)")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId:String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let token = OAuth2TokenStorage.token else { return }
        var request: URLRequest?
        request = makeLikeRequest(token,
                                  photoId: photoId,
                                  method: isLike ? "DELETE" : "POST")
        guard let request = request else { return }
        let task = URLSession.shared.object(for: request) { [weak self] (result: Result<IsLiked, Error>) in
            guard let self = self else {return}
            self.task = nil
            switch result {
            case .success(let photosResults):
                let isLiked = photosResults.photo?.isLiked ?? false
                if let index = self.photos.firstIndex(where: { $0.id == photosResults.photo?.id }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(id: photo.id,
                                         size: photo.size,
                                         createdAt: photo.createdAt,
                                         welcomeDescription: photo.welcomeDescription,
                                         thumbImageURL: photo.thumbImageURL,
                                         largeImageURL: photo.largeImageURL,
                                         isLiked: isLiked)
                    self.photos = self.photos.replaceElement(oldElement: index, withElement: newPhoto)
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func fetchImageListRequest (_ token: String, page: String, perPage: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(page)&&per_page=\(perPage)",
                                                 httpMethod: "GET",
                                                 baseURL: Constants.defaultBaseURL
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeLikeRequest(_ token: String, photoId: String, method: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "photos/\(photoId)/like",
                                                 httpMethod: method,
                                                 baseURL: Constants.defaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
        
    }
    
    func cleanSession() {
        self.task = nil
        photos = []
    }
}
