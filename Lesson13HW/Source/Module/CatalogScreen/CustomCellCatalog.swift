//
//  CustomCellCatalog.swift
//  Lesson13HW
//
//  Created by Marina Zhukova on 05.04.2024.
//

import UIKit
protocol CustomCellCatalogDelegate{
    func favoriteButtonDidTup(in cell: UITableViewCell)
}
class CustomCellCatalog : UITableViewCell{
    
    @IBOutlet weak var productCode: UILabel!
    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var manufacturedProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: CustomCellCatalogDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBAction func addToFavoriteAction(_ sender: UIButton) {
        sender.isSelected.toggle() 
        delegate?.favoriteButtonDidTup(in: self)
    }
    
}
