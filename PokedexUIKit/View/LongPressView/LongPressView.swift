//
//  LongPressView.swift
//  PokedexUIKit
//
//  Created by Maciej on 18/10/2023.
//

import UIKit
import SwiftUI

protocol LongPressViewDelegate: AnyObject {
    func dismissInfoView(withPokemon pokemon: Pokemon)
}

private enum Constants {
    static let buttonText = "View More Info"
}

final class LongPressView: UIView {
    // MARK: - Properties
    var pokemon: Pokemon? {
        didSet {
            guard let pokemon else { return }
            
            nameLabel.text = pokemon.name.capitalized
            imageView.image = pokemon.image
            typeSection.value = pokemon.type
            attackSection.value = pokemon.attack.asString
            defenseSection.value = pokemon.defense.asString
            pokedexIdSection.value = pokemon.id.asString
            descriptionLabel.text = pokemon.description
        }
    }
    
    weak var delegate: LongPressViewDelegate?
    
    private let padding = AppConstants.padding
    
    private var foregroundColor: UIColor {
        return UIColor { $0.userInterfaceStyle == .light ? .black : .white }
    }
    
    private lazy var headerContainer: UIView = {
        let view = UIView()
        view.addSubview(nameLabel)
        view.backgroundColor = Kirari.blue
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            typeSection,
            attackSection,
            defenseSection,
            pokedexIdSection
        ])
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Pokemon Name"
        label.font = .set(size: .headline, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var typeSection: InfoSectionView = {
        return InfoSectionView(type: .type)
    }()
    
    private lazy var attackSection: InfoSectionView = {
        return InfoSectionView(type: .attack)
    }()
    
    private lazy var defenseSection: InfoSectionView = {
        return InfoSectionView(type: .defense)
    }()
    
    private lazy var pokedexIdSection: InfoSectionView = {
        return InfoSectionView(type: .pokedexId)
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "BLA bla bllaedlsadasdsa d sad sad sad lsadlsa dlsa dl sald sal dlas "
        label.font = .set(size: .callout, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = Kirari.blue
        configuration.baseForegroundColor = foregroundColor
        configuration.imagePadding = AppConstants.padding / 2
        
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.setTitle(Constants.buttonText, for: .normal)
        button.titleLabel?.font = .set(size: .headline, weight: .bold)
        button.tintColor = foregroundColor
        button.addTarget(self, action: #selector(handleViewMoreInfo), for: .touchUpInside)
        button.backgroundColor = Kirari.blue
        button.layer.cornerRadius = 5
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifeycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleViewMoreInfo() {
        guard let pokemon else { return }

        delegate?.dismissInfoView(withPokemon: pokemon)
    }
}

// MARK: - Private API
private extension LongPressView {
    func setupUI() {
        applyRoundedCorners()
        
        layer.masksToBounds = true
        
        addSubview(headerContainer)
        addSubview(imageView)
        addSubview(infoStack)
        addSubview(descriptionLabel)
        addSubview(button)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerContainer.heightAnchor.constraint(equalToConstant: 50),
            headerContainer.topAnchor.constraint(equalTo: topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: padding * 2),
            
            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding * 2),
            infoStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoStack.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -padding),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            descriptionLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -padding),
            
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
}

#Preview("XD") {
    let view = LongPressView()
    
    NSLayoutConstraint.activate([
        view.heightAnchor.constraint(equalToConstant: 500),
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 64)
    ])
    
    return view
}
