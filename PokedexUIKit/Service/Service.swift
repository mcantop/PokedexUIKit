//
//  Service.swift
//  PokedexUIKit
//
//  Created by Maciej on 11/10/2023.
//

import UIKit

private enum Constants {
    static let pokemonApiUrl = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
}

private enum PokemonError: Error, LocalizedError {
    case fetchingFailed(error: Error)
    case badStatus(statusCode: Int)
    case decodingFailed(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .fetchingFailed(let error):
            return "[DEBUG] Failed to fetch with error - \(error.localizedDescription)"
        case .badStatus(let statusCode):
            return "[DEBUG] Bad status code - \(statusCode)"
        case .decodingFailed(let error):
            return "[DEBUG] Failed to decode Pokemon with error - \(error.localizedDescription)"
        }
    }
}

final class Service {
    static let shared = Service()
}

// MARK: - Public API
extension Service {
    func fetchPokemon(completion: @escaping([Pokemon]) -> Void) {
        guard let url = URL(string: Constants.pokemonApiUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                let fetchingError = PokemonError.fetchingFailed(error: error)
                print(fetchingError.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299).contains(response.statusCode) else {
                let statusError = PokemonError.badStatus(statusCode: response.statusCode)
                print(statusError.localizedDescription)
                return
            }
            
            guard let data = data?.parseData(removeString: "null,") else { return }
                        
            do {
                var decodedPokemonArray = try JSONDecoder().decode([Pokemon].self, from: data)
                
                let group = DispatchGroup()
                
                decodedPokemonArray.indices.forEach { index in
                    let urlString = decodedPokemonArray[index].imageUrl
                    
                    group.enter()
                    
                    self.fetchImage(urlString: urlString) { pokemonImage in
                        decodedPokemonArray[index].image = pokemonImage
                        
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(decodedPokemonArray.sorted(by: { $0.id < $1.id }))
                }
            } catch {
                let decodingError = PokemonError.decodingFailed(error: error)
                print(decodingError.localizedDescription)
            }
        }
        .resume()
    }
}

// MARK: - Private API
private extension Service {
    func fetchImage(urlString: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
                        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                let fetchingError = PokemonError.fetchingFailed(error: error)
                print(fetchingError.localizedDescription)
                return
            }
                        
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299).contains(response.statusCode) else {
                let statusError = PokemonError.badStatus(statusCode: response.statusCode)
                print(statusError.localizedDescription)
                return
            }
            
            guard let data,
                  let pokemonImage = UIImage(data: data) else { return }
            
            completion(pokemonImage)
        }
        .resume()
    }
}
