//
//  UpComingViewController.swift
//  NetflicClone
//
//  Created by talha polat on 29.04.2023.
//

import UIKit
protocol PopularTableViewCellDelegate{
    func didTapMovie(_ cell:UITableViewCell,viewModel:MovieDetailViewModel)
}

class UpComingViewController: UIViewController {
    var delegate :PopularTableViewCellDelegate?
    private var UpComingMovies = [Movie]()
    private let upComingTableView:UITableView = {
        let tableView = UITableView()
        tableView.register(PopularTableViewCell.self, forCellReuseIdentifier: PopularTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "UpComing Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        upComingTableView.delegate = self
        upComingTableView.dataSource = self
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(upComingTableView)
        fetchMovies()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingTableView.frame = view.bounds
    }

    
    private func fetchMovies(){
        ApiManager.shared.getMedia(url: Constants.upComingMovieUrl) {[weak self] result in
            switch result{
            case .success(let movie):
                self?.UpComingMovies = movie
                DispatchQueue.main.async {
                    self?.upComingTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension UpComingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UpComingMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularTableViewCell.identifier)as? PopularTableViewCell else{return UITableViewCell()}
        let movie = UpComingMovies[indexPath.row]
        
        cell.configureCell(movie:MediaViewModel(titleOfMedia: movie.name ?? movie.original_title ?? "Unknown Movie", posterPath: movie.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = UpComingMovies[indexPath.row]
        ApiManager.shared.getYoutubeTrailer(with: movie.name ?? movie.original_title ?? "") { result in
            switch result{
            case .success(let element):
                let model = MovieDetailViewModel(titleOfMovie: movie.name ?? movie.original_title ?? "", overviewOfMovie: movie.overview, webViewLink: element.id)
                DispatchQueue.main.async {
                    let vc = MovieDetailsViewController()
                    vc.configureUI(model: model)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        DispatchQueue.main.async {
            
        }
    }
}
