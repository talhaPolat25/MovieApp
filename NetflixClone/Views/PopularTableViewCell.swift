//
//  PopularTableViewCell.swift
//  NetflicClone
//
//  Created by talha polat on 4.05.2023.
//

import UIKit
import SDWebImage


class PopularTableViewCell: UITableViewCell {
    var delegate:PopularTableViewCellDelegate?
    static let identifier = "PopularTableViewCell"
    private let posterImageView:UIImageView={
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
   
    private let filmName:UILabel={
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Denemelerden deneme"
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let PlayButton:UIButton={
        
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        //button.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(filmName)
        contentView.addSubview(PlayButton)
    }
    
    
    required init(coder:NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        allignViews()
    }
    
    
    private func allignViews(){
        let imageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            posterImageView.widthAnchor.constraint(equalToConstant: 100)
            
        ]
        
        let labelConstraints = [
            filmName.centerYAnchor.constraint(equalTo:contentView.centerYAnchor ),
            filmName.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 50),
           // filmName.widthAnchor.constraint(equalToConstant: contentView.bounds.width - posterImageView.frame.width-20 )
            filmName.trailingAnchor.constraint(equalTo: PlayButton.leadingAnchor, constant: 15)
        ]
        
        let playButtonConstraints = [
            PlayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            PlayButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            PlayButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    func configureCell(movie:MediaViewModel){
        //filmName.text = movie.name ?? movie.original_title ?? "UnKnown Movie"
        filmName.text = movie.titleOfMedia
        guard let imageUrl = URL(string: "\(Constants.imageFetchBaseUrl)\(movie.posterPath)") else{return}
        posterImageView.sd_setImage(with: imageUrl)
    }
}
