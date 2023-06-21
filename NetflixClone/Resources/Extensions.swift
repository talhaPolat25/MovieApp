//
//  Extensions.swift
//  NetflicClone
//
//  Created by talha polat on 3.05.2023.
//

import Foundation

extension String{
    
     func capatilizeTheWord()->String{
         
         return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}
