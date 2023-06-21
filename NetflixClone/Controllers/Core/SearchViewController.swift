//
//  SearchViewController.swift
//  NetflicClone
//
//  Created by talha polat on 29.04.2023.
//

import UIKit

class SearchViewController: UIViewController {
    private var discoverMovies = [Movie]()
    private let upComingTableView:UITableView = {
        let tableView = UITableView()
        tableView.register(PopularTableViewCell.self, forCellReuseIdentifier: PopularTableViewCell.identifier)
        return tableView
    }()
    let searchDetailVC :UISearchController = {
        
        let searchDVC = UISearchController(searchResultsController: SearchDetailViewController())
        searchDVC.searchBar.placeholder = "Search Movie or Tv Shows"
        searchDVC.searchBar.barStyle = .black
        return searchDVC
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(upComingTableView)
        navigationItem.searchController = searchDetailVC
        navigationController?.navigationBar.tintColor = .white
        title = "Search"
        upComingTableView.dataSource = self
        upComingTableView.delegate = self
        fetchDiscoverMovies()
        searchDetailVC.searchResultsUpdater = self
    }
    
    private func fetchDiscoverMovies(){
        print("sıra bende ")
        ApiManager.shared.getMedia(url: Constants.discoverMovies) {[weak self] result in
            switch result{
            case .success(let movies):
                self?.discoverMovies = movies
                print(movies)
                DispatchQueue.main.async {
                    self?.upComingTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingTableView.frame = view.bounds
    }

}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoverMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularTableViewCell.identifier) as? PopularTableViewCell else{return UITableViewCell()}
        let movie = discoverMovies[indexPath.row]
        let model = MediaViewModel(titleOfMedia: movie.name ?? movie.original_title ?? "Unknown Movie", posterPath: movie.poster_path ?? "")
        cell.configureCell(movie: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension SearchViewController:UISearchResultsUpdating,SearchDetailViewControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        
        guard let query = searchbar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count>=3,
              let resultsController = searchController.searchResultsController as? SearchDetailViewController
        else {return}
        resultsController.delegate = self
        ApiManager.shared.getSearchMedia(with: query) { result in
            switch result{
            case .success(let movies):
                DispatchQueue.main.async {
                    resultsController.movies = movies
                    resultsController.searchCollectionView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    func searchDetailViewControllerDidTapped(model: MovieDetailViewModel) {
        DispatchQueue.main.async {
            let vc = MovieDetailsViewController()
            vc.configureUI(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
