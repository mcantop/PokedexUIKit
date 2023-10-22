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
    
    private lazy var longPressView: LongPressView = {
        let view = LongPressView()
        view.delegate = self
        view.backgroundColor = backgroundColor
        view.applyRoundedCorners()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(gesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    /// Needed to set a correct collection cell color before cells appear
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
    
    @objc private func handleDismissal() {
        showLongPressView(false)
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
    
    func showLongPressView(_ show: Bool) {
        visualEffectView.alpha = show ? 0 : 1
        longPressView.alpha = show ? 0 : 1
        
        if show {
            longPressView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = show ? 1 : 0
            self.longPressView.alpha = show ? 1 : 0
            self.longPressView.transform = show ? .identity : CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            guard show == false else { return }
            
            self.longPressView.removeFromSuperview()
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
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PokedexController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: AppConstants.padding, left: AppConstants.padding, bottom: AppConstants.padding, right: AppConstants.padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = (AppConstants.padding * 4) + Constants.spacingFix
        let size = (view.frame.width - padding) / 3
        return .init(width: size, height: size)
    }
}

// MARK: - PokedexCellDeleagte
extension PokedexController: PokedexCellDeleagte {
    func presentLongPressView(_ pokemon: Pokemon) {
        longPressView.pokemon = pokemon
        
        view.addSubview(visualEffectView)
        view.addSubview(longPressView)

        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            longPressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            longPressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            longPressView.widthAnchor.constraint(equalToConstant: view.frame.width - 64),
            longPressView.heightAnchor.constraint(equalToConstant: 500),
        ])
        
        showLongPressView(true)
    }
}

// MARK: - LongPressViewDelegate
extension PokedexController: LongPressViewDelegate {
    func dismissInfoView(withPokemon pokemon: Pokemon) {
        showLongPressView(false)
    }
}

#Preview("PokedexController") {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = AppConstants.padding
    layout.minimumLineSpacing = AppConstants.padding
    
    let controller = PokedexController(collectionViewLayout: layout)
    
    return controller
}
