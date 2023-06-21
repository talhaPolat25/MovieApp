//
//  MediaCollectionViewCell.swift
//  NetflicClone
//
//  Created by talha polat on 4.05.2023.
//

import UIKit
import SDWebImage
class MediaCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MediaCollectionViewCell"
    
    
   private let PosterImageView:UIImageView={
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private func configureGradient(){
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.frame = contentView.frame
        layer.addSublayer(gradient)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(PosterImageView)
       // configureGradient()
        
    }
   
    required init(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        PosterImageView.frame = contentView.bounds
    }
    
    public func configurePosterToCell(url:String){
        let fullUrl = "https://image.tmdb.org/t/p/w500\(url)"
        guard let url = URL(string: fullUrl)else{return}
        
        PosterImageView.sd_setImage(with: url)
    }
}
