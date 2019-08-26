import Foundation

enum NetworkError {
	case unknownError
	case clientError
	case unauthorized
	case notFound
	case unreachable
}

class BaseBackendOperation: AsyncOperation {
	internal let session: URLSession
	
	override init() {
		//создание URLSession без кеша
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringLocalCacheData
		config.urlCache = nil
		session = URLSession.init(configuration: config)
		super.init()
	}
}
