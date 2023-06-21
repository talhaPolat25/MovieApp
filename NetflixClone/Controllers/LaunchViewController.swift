//
//  LaunchViewController.swift
//  NetflicClone
//
//  Created by talha polat on 8.05.2023.
//

import UIKit

class LaunchViewController: UIViewController {
    var sayac = 0
  /*  private let label:UILabel = {
        let lbl = UILabel()
        
        let isim = "TalhaFlix"
        let str = NSMutableAttributedString(string:isim)
        //let range1 = (isim as NSString).range(of:"Talha")
        //let range2 = (isim as NSString).range(of:"Flix")
        //str.addAttribute(.foregroundColor, value: UIColor.red, range: range1)
        //str.addAttribute(.foregroundColor, value: UIColor.white, range: range2)
        let atributedString = NSMutableAttributedString()
        let yazı1 = NSAttributedString(string: "Talha",attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        atributedString.append(yazı1)
        let yazi2 = NSAttributedString(string: "Flix", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white ])
        atributedString.append(yazi2)
        lbl.attributedText = atributedString
        lbl.font = .boldSystemFont(ofSize: 25)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()*/
    private let LogoimagiView:UIImageView = {
        let image = UIImage(named: "tp")
        image?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(LogoimagiView)
       // view.addSubview(label)
        view.backgroundColor = .black
        applyConstraints()
        let timer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(presentToTabBar), userInfo: nil, repeats: true)
        
    }
    
    @objc func presentToTabBar(){
        sayac += 1
        print(sayac)
        if sayac == 2{
            let vc = MainTabBarController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            Timer().invalidate()
            
        }
    }
    
    private func applyConstraints(){
        
        let logoImageViewConstrains = [
            LogoimagiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            LogoimagiView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -20),
            LogoimagiView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            LogoimagiView.heightAnchor.constraint(equalTo: LogoimagiView.widthAnchor,multiplier:1.5)
        ]
       /* let lblCons = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: LogoimagiView.bottomAnchor,constant: -30),
            label.heightAnchor.constraint(equalToConstant:30)
        ]*/
        
        
        NSLayoutConstraint.activate(logoImageViewConstrains)
        //NSLayoutConstraint.activate(lblCons)
    }
}
