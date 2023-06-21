//
//  DataBaseManager.swift
//  NetflicClone
//
//  Created by talha polat on 13.05.2023.
//

import Foundation
import UIKit
import CoreData

class DataBaseManager{
 

    static let shared = DataBaseManager()
    
    func addMovieToDataBase(with model:Movie,completion: @escaping(Result<Void,Error>)-> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let movieData = MovieData(context: context)
        movieData.id = Int64(model.id)
        movieData.name = model.name
        movieData.original_title = model.original_title
        movieData.overiview = model.overview
        movieData.poster_path = model.poster_path
        movieData.title = model.title
        do {
            try context.save()
            completion(.success(()))
        } catch  {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    func getMoviesFromDatabase(completion:@escaping (Result<[MovieData],Error>?)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<MovieData> = MovieData.fetchRequest()
        do {
             let movies = try context.fetch(request)
            completion(.success(movies))
        } catch  {
            completion(.failure(error))
        }
    }
    
    func deleteMovieFromDataBase(movie:MovieData,completion:@escaping (Result<Void,Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let contextView = appDelegate.persistentContainer.viewContext
            contextView.delete(movie)
        do {
            try contextView.save()
            completion(.success(()))
        } catch  {
            completion(.failure(error))
        }
          
        
    }
}
