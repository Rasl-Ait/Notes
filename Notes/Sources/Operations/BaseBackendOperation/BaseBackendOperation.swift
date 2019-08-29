import Foundation

enum NetworkError {
	case unknownError
	case clientError
	case unauthorized
	case notFound
	case unreachable
}

class BaseBackendOperation: AsyncOperation {
	override init() {
		super.init()
	}
}
