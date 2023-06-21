//
//  MovieDetailsViewController.swift
//  NetflicClone
//
//  Created by talha polat on 10.05.2023.
//

import UIKit
import WebKit
class MovieDetailsViewController: UIViewController {
    
    private let webView:WKWebView={
        
        
            let webView = WKWebView()
            webView.translatesAutoresizingMaskIntoConstraints = false
            return webView
        
        
    }()
    private let titleOfMovieLabel:UILabel={
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.text = "Harry Potter"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overiviewLabel:UILabel={
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "This movie is my childhood's favourite movie"
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let downloadButton:UIButton={
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(downloadButton)
        view.addSubview(overiviewLabel)
        view.addSubview(titleOfMovieLabel)
        
        configureConstraints()
    }
    
    private func configureConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        let titleOfMovieLabelConstraints = [
            titleOfMovieLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleOfMovieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let overViewLabelConstraints = [
            overiviewLabel.topAnchor.constraint(equalTo: titleOfMovieLabel.bottomAnchor, constant: 15),
            overiviewLabel.leadingAnchor.constraint(equalTo: titleOfMovieLabel.leadingAnchor),
            overiviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-10)
        ]
        let buttonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overiviewLabel.bottomAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 150)        ]
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleOfMovieLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(buttonConstraints)
        
    }
    
    func configureUI(model : MovieDetailViewModel){
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.webViewLink.videoId)") else {return}
        webView.load(URLRequest(url: url))
        titleOfMovieLabel.text = model.titleOfMovie
        overiviewLabel.text = model.overviewOfMovie
    }
}
