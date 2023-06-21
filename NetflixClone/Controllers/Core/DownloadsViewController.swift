//
//  DownloadsViewController.swift
//  NetflicClone
//
//  Created by talha polat on 29.04.2023.
//

import UIKit
import CoreData
class DownloadsViewController: UIViewController {
    
    private var movies = [MovieData]()
    private let downloadsTableView:UITableView={
        let table = UITableView()
        table.register(PopularTableViewCell.self, forCellReuseIdentifier: PopularTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private func configureUI(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Downloads"
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .systemBackground
        view.addSubview(downloadsTableView)
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
        getMovies()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) {[weak self] _ in
            self?.getMovies()
        }
        
    }

   override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         downloadsTableView.frame = view.bounds
     }
    func getMovies(){
        DataBaseManager.shared.getMoviesFromDatabase {[weak self]  result in
            switch result{
            case .success(let data):
                self?.movies = data
                DispatchQueue.main.async {
                    self?.downloadsTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            default:
                print("")
            }
            
        }
    }

}

extension DownloadsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularTableViewCell.identifier) as? PopularTableViewCell else{return UITableViewCell()}
        let movie = movies[indexPath.row]
        let model = MediaViewModel(titleOfMedia: movie.original_title ?? movie.name ?? "", posterPath: movie.poster_path ?? "")
        cell.configureCell(movie: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(actionProvider: { _ in
           
            let action = UIAction(title: "Delete the movie") { action in
                let movie = self.movies[indexPath.row]
                let appDelegaete = UIApplication.shared.delegate as? AppDelegate
                let context = appDelegaete?.persistentContainer.viewContext
                do{
                    context?.delete(movie)
                    try context?.save()
                    DispatchQueue.main.async {
                        self.getMovies()
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
            }
            return UIMenu(options: .displayInline,children: [action])
        })
        
        return config
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        
        ApiManager.shared.getYoutubeTrailer(with: "\(movie.name ?? movie.original_title ?? "") trailer") { result in
            switch result{
            case .success(let element):
                let model = MovieDetailViewModel(titleOfMovie: movie.name ?? movie.original_title ?? "", overviewOfMovie: movie.overiview ?? "", webViewLink: element.id)
                DispatchQueue.main.async {
                    let vc = MovieDetailsViewController()
                    vc.configureUI(model: model)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            DataBaseManager.shared.deleteMovieFromDataBase(movie: self.movies[indexPath.row]) { result in
                switch result{
                case .success(()):
                    self.movies.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(_):
                    print("Hata oluştu")
                }
            }
        }
    }
}
