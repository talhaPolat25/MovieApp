//
//  SearchDetailViewController.swift
//  NetflicClone
//
//  Created by talha polat on 7.05.2023.
//

import UIKit


protocol SearchDetailViewControllerDelegate:AnyObject{
    func searchDetailViewControllerDidTapped(model:MovieDetailViewModel)
}


class SearchDetailViewController: UIViewController {
    
    public var movies:[Movie]=[Movie]()
    public var delegate:SearchDetailViewControllerDelegate?
    public let searchCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-10 , height: 200)
        layout.minimumInteritemSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchCollectionView)
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }

    

}

extension SearchDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else{return UICollectionViewCell()}
        let movie = movies[indexPath.row]
        cell.configurePosterToCell(url: movie.poster_path ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let titleOfMovie = movie.original_title ?? movie.name ?? ""
        print(titleOfMovie)
        ApiManager.shared.getYoutubeTrailer(with: "\(movie.original_title ?? movie.name) trailer") {result in
            switch result{
            case .success(let videoId):
                //print(videoId.id.videoId)
                let model = MovieDetailViewModel(titleOfMovie: titleOfMovie, overviewOfMovie: movie.overview, webViewLink: videoId.id)
                self.delegate?.searchDetailViewControllerDidTapped(model: model)
                print("çalıştı")
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
