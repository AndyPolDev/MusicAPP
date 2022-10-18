import UIKit

class DetailAlbumViewController: UIViewController {
    
    private let albumLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Name album"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name artist"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Release date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackCountLabel: UILabel = {
        let label = UILabel()
        label.text = "10 tracks"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(SongsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var stackView = UIStackView()
    
    var album: Album?
    var songs = [Results]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegate()
        setModel()
        fetchSongs(album: album)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(albumLogo)
        
        stackView = UIStackView(arrangedSubviews: [albumNameLabel,
                                                   artistNameLabel,
                                                   releaseDateLabel,
                                                   trackCountLabel],
                                axis: .vertical,
                                spacing: 10,
                                distribution: .fillProportionally)
        
        view.addSubview(stackView)
        view.addSubview(collectionView)
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setModel() {
        guard let album = album else { return }
        
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) tracks"
        releaseDateLabel.text = setDateFormat(date: album.releaseDate)
        
        guard let url = album.artworkUrl100 else { return }
        setImage(urlString: url)
    }
    
    private func setDateFormat(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let backendDate = formatter.date(from: date) else { return "" }
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let date = formatDate.string(from: backendDate)
        return date
    }
    
    private func setImage(urlString: String?) {
        
        if let urlString = urlString {
            NetWorkRequest.shared.requestData(urlString: urlString) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.albumLogo.image = image
                case .failure(let error):
                    self?.albumLogo.image = nil
                    print("No album logo" + error.localizedDescription)
                }
            }
        } else {
            albumLogo.image = nil
        }
    }
    
    private func fetchSongs(album: Album?) {
        
        guard let album = album else { return }
        
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
        NetWorkDataFetch.shared.fetchSongs(urlString: urlString) { [weak self] songsModel, error in
            if error == nil {
                guard let songsModel = songsModel else { return }
                self?.songs = songsModel.results
                self?.collectionView.reloadData()
            } else {
                print(error!.localizedDescription)
                self?.alertOK(title: "Error", message: error!.localizedDescription)
            }
        }
    }
}

//MARK: CollectionView Delegate

extension DetailAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SongsCollectionViewCell
        let songName = songs[indexPath.row].trackName
        cell.nameSongLabel.text = songName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: 20
        )
    }
}

// MARK: - SetConstraints

extension DetailAlbumViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            albumLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            albumLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            albumLogo.heightAnchor.constraint(equalToConstant: 100),
            albumLogo.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 17),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}
