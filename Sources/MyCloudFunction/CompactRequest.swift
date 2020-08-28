// HTTP请求概要
struct CompactRequest: Codable {
    let requestId: String
    let httpMethod: String
    let headers: [String : String]
    let path: String
    let body: String?
    let query: [String : String]
}