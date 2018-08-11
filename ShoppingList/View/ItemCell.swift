//
//  ItemCell.swift
//  DreamLister
//
//  Created by Faisal Babkoor on 4/6/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var typeItemLbl: UILabel!
    
    func confeger(item: Item){
        self.title.text = item.title
        self.price.text = "\(item.price) ريال"
        self.details.text = item.details
        self.thumb.image = item.toImage?.image as? UIImage
        self.typeItemLbl.text = item.toItemType?.type
    }
}
