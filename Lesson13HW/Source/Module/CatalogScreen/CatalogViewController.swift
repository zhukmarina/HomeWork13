//
//  CatalogViewController.swift
//  Lesson13HW
//

//

import UIKit

class CatalogViewController: UIViewController {
    
    @IBOutlet weak var contentView: CatalogView!
    var model: CatalogModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        model.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.saveChangesIfNeeded()
    }
    
    private func setupInitialState() {
        
        title = "Catalog"
        
        model = CatalogModel()
        model.delegate = self
        
        contentView.delegate = self
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        
        let nib = UINib(nibName: "CustomCellCatalog", bundle: nil)
        contentView.tableView.register(nib, forCellReuseIdentifier: "CustomCellCatalog")
    }
}

// MARK: - CatalogModelDelegate
extension CatalogViewController: CatalogModelDelegate {
    
    func dataDidLoad() {
        contentView.tableView.reloadData()
    }
}

// MARK: - CatalogViewDelegate
extension CatalogViewController: CatalogViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.pcItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellCatalog", for: indexPath) as? CustomCellCatalog else {
            assertionFailure()
            return UITableViewCell()
        }
        
        let item = model.pcItems[indexPath.row]
        
        cell.nameProductLabel.text = item.name
        cell.productCode.text = "Код товару: \(item.id)"
        cell.manufacturedProduct.text = "\(item.manufacturer), \(item.model)"
        cell.priceProduct.text = "\(item.price)\(item.currency)"
        cell.favoriteButton.isSelected = item.isFavorite ?? false
          
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
   
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            
//            let isFavorite = !model.pcItems[indexPath.row].favorite()
//            model.updateItem(with: isFavorite, at: indexPath.row)
//            
//            let cell = tableView.cellForRow(at: indexPath)
//            cell?.accessoryType = isFavorite ? .checkmark : .none
//        }
     
    
}

extension CatalogViewController: CustomCellCatalogDelegate {
    func favoriteButtonDidTup(in cell: UITableViewCell) {
        guard let indexPath = contentView.tableView.indexPath(for: cell) else {
            return
        }
        
        let isFavorite = !model.pcItems[indexPath.row].favorite()
        model.updateItem(with: isFavorite, at: indexPath.row)
        
      
        contentView.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
