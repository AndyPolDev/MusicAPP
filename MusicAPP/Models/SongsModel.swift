import Foundation

struct SongsModel: Decodable {
    let results: [Results]
}

struct Results: Decodable {
    let trackName: String?
}
