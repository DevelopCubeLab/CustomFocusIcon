import Foundation
import UIKit

protocol GridCellDelegate: AnyObject {
    func didSelectSymbol(_ symbol: String)
}

class GridCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var delegate: GridCellDelegate?
    
    private var symbols: [String] = []
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2 // 列间距
        layout.minimumLineSpacing = 2 // 行间距
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    func configure(with symbols: [String]) {
        self.symbols = symbols
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SymbolCollectionViewCell.self, forCellWithReuseIdentifier: "SymbolCollectionViewCell")
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SymbolCollectionViewCell", for: indexPath) as! SymbolCollectionViewCell
        cell.configure(with: symbols[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSymbol = symbols[indexPath.item]
        delegate?.didSelectSymbol(selectedSymbol) // 调用代理方法
        
    }
}
