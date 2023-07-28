import Foundation

extension URLSession {
        func object<T: Decodable>(
        for reguest: URLRequest,
        comletion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = URLSession.shared.data (for: reguest) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<T, Error> in
                Result { try decoder.decode(T.self, from: data)}
            }
            comletion(response)
        }
        return task
    }
}
