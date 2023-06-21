//
//  TableHeaderView.swift
//  NetflicClone
//
//  Created by talha polat on 1.05.2023.
//

import UIKit
import SDWebImage
class TableHeaderView: UIView {

    private let playButton:UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

   
    private let headerImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        applyGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraintsToButtons()
    }
    
    
    
    private func applyConstraintsToButtons(){
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 125)
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 125)
        
        ]
        
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
        
    }
    
    
    
    
    private func applyGradient(){
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    public func configureHeader(model:MediaViewModel){
        //guard let fullUrl = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath)") else{return}
        //headerImageView.sd_setImage(with: fullUrl)
        DispatchQueue.main.async {
            self.headerImageView.image = UIImage(named:"dune")

        }
    }
   
    
   
    required init(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = bounds
    }
    
    
}
