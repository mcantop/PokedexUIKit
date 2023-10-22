//
//  InfoSectionView.swift
//  PokedexUIKit
//
//  Created by Maciej on 22/10/2023.
//

import UIKit

enum PokemonInfoSectionType: String, CaseIterable {
    case type
    case attack
    case defense
    case pokedexId
    case height
    case weight
    
    var text: String {
        switch self {
        case .pokedexId:
            return "Pokedex Id"
        default:
            return rawValue.capitalized
        }
    }
    
    var longPressSections: [PokemonInfoSectionType] {
        return [.type, .attack, .defense, .pokedexId]
    }
}

final class InfoSectionView: UIView {
    // MARK: - Properties
    var value: String {
        didSet {
            rightLabel.text = value.capitalized
        }
    }
    
    private let type: PokemonInfoSectionType
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.text = "\(type.text): "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.text = value
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .set(size: .body, weight: .semibold)
        return label
    }()
    
    private lazy var labelsStack = {
        let stackView = UIStackView(arrangedSubviews: [
            leftLabel, rightLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1),
        ])

        return view
    }()
    
    // MARK: - Lifecycle
    init(type: PokemonInfoSectionType, value: String = "") {
        self.type = type
        self.value = value
        
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private API
private extension InfoSectionView {
    func setupUI() {
        addSubview(labelsStack)
        addSubview(seperatorView)
    }
    
    func setupConstraints() {
        let padding = AppConstants.padding
        
        NSLayoutConstraint.activate([
            labelsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelsStack.topAnchor.constraint(equalTo: topAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: seperatorView.topAnchor, constant: -12),
            
            seperatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -padding),
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

#Preview("InfoSectionView") {
    InfoSectionView(type: .attack, value: "666")
}
