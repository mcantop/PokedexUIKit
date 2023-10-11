//
//  PokedexController.swift
//  PokedexUIKit
//
//  Created by Maciej on 07/10/2023.
//

import UIKit

private enum Constants {
    static let spacing = 16.0
    
    /// For some reason extra spacing of 4.0 is needed, otherwise layout breaks
    static let spacingFix = 4.0
}

final class PokedexController: UICollectionViewController {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - Selectors
    @objc private func toggleSearchBar() {
        print("[DEBUG] Toggle search bar")
    }
}

// MARK: - Private API
private extension PokedexController {
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Kirari.blue
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.title = "Pokedex"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(toggleSearchBar)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    func setupUI() {
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: PokedexCell.reuseIdentifier)
    }
}

// MARK: - CollectionView API
extension PokedexController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCell.reuseIdentifier, for: indexPath) as! PokedexCell
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PokedexController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: Constants.spacing, left: Constants.spacing, bottom: Constants.spacing, right: Constants.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = (Constants.spacing * 2) + Constants.spacing + Constants.spacingFix
        let size = (view.frame.width - padding) / 3
        return CGSize(width: size, height: size)
    }
}
