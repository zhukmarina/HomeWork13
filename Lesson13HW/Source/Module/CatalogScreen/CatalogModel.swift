//
//  CatalogModel.swift
//  Lesson13HW
//

//

import Foundation

protocol CatalogModelDelegate: AnyObject {
    
    func dataDidLoad()
}

class CatalogModel {
    
    weak var delegate: CatalogModelDelegate?
    private let dataLoader = DataLoaderService()
    private let localStorage = LocalStorageService()
    
    var pcItems: [Pc] = []
    
    func loadData() {
        dataLoader.loadCatalog { [weak self] catalog in
            guard let self = self else { return }
            
            let savedItems = localStorage.getFavorites()
            
            if !savedItems.isEmpty {
                self.pcItems = catalog?.data ?? []
                for item in savedItems {
                    if let index = self.pcItems.firstIndex(where: { $0.id == item.id }) {
                        self.pcItems[index].isFavorite = true
                    }
                }
            } else {
                self.pcItems = catalog?.data ?? []
            }
            
            self.delegate?.dataDidLoad()
        }
    }
    
    func updateItem(with isFavorite: Bool, at index: Int) {
        pcItems[index].isFavorite = isFavorite
    }
    
    func saveChangesIfNeeded() {
        let favoriteItems = getFavoriteItems()
        let savedItems = localStorage.getFavorites()
        
        guard savedItems != favoriteItems else { return }
        
        let totalSet: Set<Favorite> = Set(savedItems + favoriteItems)
        localStorage.saveFavorites(Array(totalSet))
    }
    
    func getFavoriteItems() -> [Favorite] {
        return pcItems.filter({ $0.favorite() }).compactMap {
            Favorite(
                id: $0.id,
                name: $0.name,
                manufacturer: $0.manufacturer,
                model: $0.model
            )
        }
    }
}
