import Foundation

class NetWorkDataFetch {
    
    static let shared = NetWorkDataFetch()
    
    private init() {}
    
    func fetchAlbum(urlString: String, responce: @escaping (AlbumModel?, Error?) -> Void) {
        
        NetWorkRequest.shared.requestData(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let albums = try JSONDecoder().decode(AlbumModel.self, from: data)
                    responce(albums, nil)
                } catch let jsonError {
                    print("Failed to decode JSON: \(jsonError.localizedDescription)")
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
    
    func fetchSongs(urlString: String, responce: @escaping (SongsModel?, Error?) -> Void) {
        
        NetWorkRequest.shared.requestData(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let albums = try JSONDecoder().decode(SongsModel.self, from: data)
                    responce(albums, nil)
                } catch let jsonError {
                    print("Failed to decode JSON: \(jsonError.localizedDescription)")
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
}

