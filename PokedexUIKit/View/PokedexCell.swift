//
//  PokedexCell.swift
//  PokedexUIKit
//
//  Created by Maciej on 07/10/2023.
//

import UIKit

private enum Constants {
    static let labelHeight = 32.0
}

final class PokedexCell: UICollectionViewCell, Reusable {
    // MARK: - Properties
    var pokemon: Pokemon? {
        didSet {
            nameLabel.text = pokemon?.name.capitalized
            imageView.image = pokemon?.image
        }
    }
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Kirari.blonde
        view.addSubview(imageView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Kirari.blue
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .set(size: .headline, weight: .semibold)
        label.text = "Bulbasaur"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private API
private extension PokedexCell {
    func setupUI() {
        roundedCorners()
        
        clipsToBounds = true /// Fixes not working corner radius
        
        addSubview(imageContainer)
        addSubview(nameContainer)
    }
    
    func setupConstraints() {
        let spacing = AppConstants.spacing / 2
        
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: topAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: frame.height - Constants.labelHeight),
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            imageView.bottomAnchor.constraint(equalTo: nameContainer.topAnchor, constant: -spacing),
            
            nameContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameContainer.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            nameContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
