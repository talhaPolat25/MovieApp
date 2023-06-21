//
//  ApiManager.swift
//  NetflicClone
//
//  Created by talha polat on 3.05.2023.
//

import Foundation
import Alamofire
struct Constants{
    
    //static let baseUrl:String = "https://api.themoviedb.org"
    static let apiKey:String = "4f2ca9826ec85189db31539ace5eb27d"
    static let trendingMoviesUrl = "https://api.themoviedb.org/3/trending/all/day?api_key=4f2ca9826ec85189db31539ace5eb27d"
    static let popularMoviesUrl = "https://api.themoviedb.org/3/movie/popular?api_key=4f2ca9826ec85189db31539ace5eb27d&language=en-US&page=1"
    static let upComingMovieUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=4f2ca9826ec85189db31539ace5eb27d&language=en-US&page=1"
    static let trendingTvUrl = "https://api.themoviedb.org/3/trending/tv/week?api_key=4f2ca9826ec85189db31539ace5eb27d"
    static let topRated = "https://api.themoviedb.org/3/movie/top_rated?api_key=4f2ca9826ec85189db31539ace5eb27d&language=en-US&page=1"
    static let discoverMovies = "https://api.themoviedb.org/3/discover/movie?api_key=4f2ca9826ec85189db31539ace5eb27d&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
    static let imageFetchBaseUrl = "https://image.tmdb.org/t/p/w500"
    static let searchBaseUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.apiKey)&query="
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?q="
    static let youtubeApiKey = "AIzaSyB06BMVBImzvfC5SI8fn8UPM_0EN4PV7VE"
    
}
enum ApiErrors:String,Error{
    case getDataError
    case jsonParseError="olmadı"
}

class ApiManager{
    static let shared = ApiManager()
     
    func getMedia(url:String,completion :@escaping (Result<[Movie],ApiErrors>)->Void){
        guard let url = URL(string: url)else{return}
        print(url)
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){ data, _, error in
            guard let data = data ,  error == nil else{
                return
            }
            do {
                let results = try JSONDecoder().decode(Media.self, from: data)
                completion(.success(results.results))
            } catch  {
                print("baba parçalayamadık")
                completion(.failure(.jsonParseError))
            }
            
        }
        task.resume()
    }
    
    func getSearchMedia(with query:String,completion: @escaping((Result<[Movie],Error>)->Void)){
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        guard let url = URL(string: "\(Constants.searchBaseUrl)\(query!)") else {return}
        print(url)
        AF.request(url).response { response in
            switch response.result{
            case .success(let moviesData):
                guard let moviesData = moviesData else{return}
                do {
                    let movies = try JSONDecoder().decode(Media.self, from:moviesData)
                    completion(.success(movies.results))
                } catch  {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getYoutubeTrailer(with query:String,completion: @escaping (Result<YoutubeSearchElement,Error>)-> Void){
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        guard let url = URL(string: "\(Constants.youtubeBaseURL)\(query!)&key=\(Constants.youtubeApiKey)")else{return}
        print("Baba hele bakisannn \n \(url)")
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{return}
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                print("buraya da girdi: -> \(results.items[0].id.videoId)")
                
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
}
