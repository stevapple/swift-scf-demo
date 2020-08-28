import TencentSCFEvents
import TencentSCFRuntime

SCF.run { (context, event: APIGateway.Request<String>, callback: @escaping (Result<APIGateway.Response, Error>) -> Void) in
    switch (event.httpMethod, event.path) {
        // 返回 POST body
        case (.POST, "/echo/body"):
            callback(.success(.init(statusCode: .ok, body: event.body)))

        // 返回一个固定的用户
        case (.GET, "/user"):
            let user = User(name: "张三", age: 28)
            callback(.success(.init(statusCode: .ok, codableBody: user)))

        // 返回重新封装的请求
        case (_, let path):
            // 判断路径以 /echo/request 开头
            if path.starts(with: "/echo/request") {
                let compactRequest = CompactRequest(
                    requestId: context.requestID,
                    httpMethod: event.httpMethod.rawValue,
                    headers: event.headers,
                    path: event.path,
                    body: event.body,
                    query: event.query
                )
                callback(.success(.init(statusCode: .ok, codableBody: compactRequest)))
            } else {
                fallthrough
            }

        // 没有 API，抛出错误
        default:
            callback(.failure(MyError.unsupported(event.httpMethod, event.path)))
    }
}

// 自定义错误模型
enum MyError: Error, CustomStringConvertible {
    case unsupported(HTTPMethod, String)

    var description: String {
        switch self {
            case .unsupported(let method, let path):
            return "Unsupported API endpoint: \(method.rawValue) \(path)"
        }
    }
}