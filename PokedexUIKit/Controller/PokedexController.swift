//
//  PokedexController.swift
//  PokedexUIKit
//
//  Created by Maciej on 07/10/2023.
//

import UIKit

private enum Constants {
    /// For some reason extra spacing of 4.0 is needed, otherwise layout breaks
    static let spacingFix = 4.0
    static let appearAnimationDuration = 0.5
    
    enum Appearance {
        static let hidden: Float = 0
        static let visible: Float = 1
    }
}

final class PokedexController: UICollectionViewController {
    // MARK: - Properties
    var pokemon = [Pokemon]()
    
    private let service = Service.shared
    
    /// Needed
    private var backgroundColor: UIColor {
        return UIColor { $0.userInterfaceStyle == .light ? .white : .black }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        setupNavigationBar()
        
        fetchPokemon()
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
        view.backgroundColor = backgroundColor
        
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: PokedexCell.reuseIdentifier)
        collectionView.layer.opacity = Constants.Appearance.hidden
    }
    
    func fetchPokemon() {
        service.fetchPokemon { pokemon in
            DispatchQueue.main.async {
                self.pokemon = pokemon
                self.collectionView.reloadData()
                
                self.animateAppearance()
            }
        }
    }
    
    func animateAppearance() {
        UIView.animate(withDuration: Constants.appearAnimationDuration, delay: .zero, options: [.curveEaseIn]) {
            self.collectionView.layer.opacity = Constants.Appearance.visible
        }
    }
}

// MARK: - CollectionView API
extension PokedexController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCell.reuseIdentifier, for: indexPath) as! PokedexCell
        cell.pokemon = pokemon[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PokedexController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: AppConstants.spacing, left: AppConstants.spacing, bottom: AppConstants.spacing, right: AppConstants.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = (AppConstants.spacing * 4) + Constants.spacingFix
        let size = (view.frame.width - padding) / 3
        return .init(width: size, height: size)
    }
}
