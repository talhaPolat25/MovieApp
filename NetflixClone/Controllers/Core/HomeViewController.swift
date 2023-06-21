//
//  HomeViewController.swift
//  NetflicClone
//
//  Created by talha polat on 29.04.2023.
//

import UIKit
import CoreData

enum SectionsForMedia:Int{
    
    case TrendingMovie = 0
    case Popular = 1
    case TrendingTv = 2
    case UpComingMovies = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    var headerView:TableHeaderView?
    let titlesOfSections:[String] = ["Trending Movie","Popular","Trending TV","Upcoming Movies","Top Rated"]
    var sayac=5
    var timer:Timer?
    
    private let HometableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionCellTableViewCell.self, forCellReuseIdentifier: CollectionCellTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(HometableView)
        HometableView.delegate = self
        HometableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        headerView = TableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        HometableView.tableHeaderView = headerView
        configureTableHeaderView()
        configureNavBar()
       // timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printleBaba), userInfo: nil, repeats: true)
        
    }
    
    private func configureTableHeaderView(){
        ApiManager.shared.getMedia(url: Constants.trendingMoviesUrl) {[weak self] resulst in
            switch resulst{
            case .success(let movies):
                let movie = movies.randomElement()
                self?.headerView?.configureHeader(model: MediaViewModel(titleOfMedia: movie?.original_title ?? "", posterPath: movie?.poster_path ?? ""))
                
            case .failure(let error):
                print(error)
            }
        }

    }
   
    private func configureNavBar(){
       let Image = UIImage(named: "tp")
        let netflixImage = Image?.withRenderingMode(.alwaysOriginal)
      
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixImage, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage( systemName: "play.circle"), style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .white
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        HometableView.frame = view.bounds
    }
    
   
   

}



extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return titlesOfSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCellTableViewCell.identifier)as? CollectionCellTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section{
        case SectionsForMedia.TrendingMovie.rawValue:
            ApiManager.shared.getMedia(url: Constants.trendingMoviesUrl) { resulst in
                switch resulst{
                case .success(let movie):
                    cell.fetchMedia(media: movie)
                    
                case .failure(let error):
                    print(error)
                }
            }
        case SectionsForMedia.Popular.rawValue:
            ApiManager.shared.getMedia(url: Constants.popularMoviesUrl) { resulst in
                switch resulst{
                case .success(let movie):
                    cell.fetchMedia(media: movie)
                case .failure(let error):
                    print(error)
                }
            }
        case SectionsForMedia.TrendingTv.rawValue:
            ApiManager.shared.getMedia(url: Constants.trendingTvUrl) { resulst in
                switch resulst{
                case .success(let movie):
                    cell.fetchMedia(media: movie)
                case .failure(let error):
                    print(error)
                }
            }
        case SectionsForMedia.UpComingMovies.rawValue:
            ApiManager.shared.getMedia(url: Constants.upComingMovieUrl) { resulst in
                switch resulst{
                case .success(let movie):
                    cell.fetchMedia(media: movie)
                case .failure(let error):
                    print(error)
                }
            }
        case SectionsForMedia.TopRated.rawValue:
            ApiManager.shared.getMedia(url: Constants.topRated) { resulst in
                switch resulst{
                case .success(let movie):
                    cell.fetchMedia(media: movie)
                case .failure(let error):
                    print(error)
                }
            }
        default:return UITableViewCell()
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titlesOfSections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{return}
        header.textLabel?.font = .boldSystemFont(ofSize: 18)
        header.textLabel?.textColor = .white
        header.textLabel?.frame = CGRect(x: Int(header.bounds.origin.x)+20, y: Int(header.bounds.origin.y), width: 100, height:Int(header.bounds.height))
        header.textLabel?.text = header.textLabel?.text?.capatilizeTheWord()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultoffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
       
    }
}
extension HomeViewController:CollectionCellTableViewCellDelegate{
    func goturBeniGittiginYere() {
        DispatchQueue.main.async {
            let vc = UpComingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tapCollectionCell(tableViewCell: UITableViewCell, previewViewModel: MovieDetailViewModel) {
        DispatchQueue.main.async {
            let vc = MovieDetailsViewController()
            vc.configureUI(model: previewViewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}
