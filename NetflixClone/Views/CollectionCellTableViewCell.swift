//
//  CollectionCellTableViewCell.swift
//  NetflicClone
//
//  Created by talha polat on 30.04.2023.
//

import UIKit

protocol CollectionCellTableViewCellDelegate{
    
    func tapCollectionCell(tableViewCell:UITableViewCell,previewViewModel:MovieDetailViewModel)
    func goturBeniGittiginYere()
}


class CollectionCellTableViewCell: UITableViewCell {
    
    private var  mediaS:[Movie] = [Movie]()
    var delegate:CollectionCellTableViewCellDelegate?

  static let identifier = "CollectionCellTableViewCell"
  /*  var filmName:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    */

    
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        return collection
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBrown
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        print(mediaS)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init(coder:NSCoder) {
        fatalError()
    }
    public func fetchMedia(media:[Movie]){
        mediaS = media
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


extension CollectionCellTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaS.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell{
            cell.configurePosterToCell(url: mediaS[indexPath.row].poster_path ?? "")
           return cell
        } else{
            return UICollectionViewCell()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = mediaS[indexPath.row]
        ApiManager.shared.getYoutubeTrailer(with: "\( movie.name ?? movie.original_title) original trailer") { result in
            switch result{
            case .success(let videoElement):
                let view = MovieDetailViewModel(titleOfMovie: movie.name ?? movie.original_title ?? "" , overviewOfMovie: movie.overview, webViewLink: videoElement.id )
                self.delegate?.tapCollectionCell(tableViewCell: self, previewViewModel: view)
                print(videoElement)
            case .failure(let error):
               print(error)
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil,previewProvider: nil){_ in
            let action = UIAction(title: "Download",state:.off) { action in
                let movie = self.mediaS[indexPaths[0].row]
                DataBaseManager.shared.addMovieToDataBase(with: movie) { result in
                    switch result{
                    case .success(()):
                        NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                        print("kayıtlı")
                    case.failure(let error):
                        print(error)
                    }
                }
            }
            return UIMenu(options:.displayInline,children: [action])
        }
       return configuration
    }
}
