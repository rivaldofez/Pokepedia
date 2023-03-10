//
//  DetailPokemonUseCase.swift
//  Pokepedia
//
//  Created by Rivaldo Fernandes on 14/02/23.
//

import Foundation
import RxSwift

protocol DetailPokemonUseCase {
    func getPokemonSpecies(id: Int) -> Observable<PokemonSpecies>
}

class DetailPokemonInteractor: DetailPokemonUseCase {
    private let repository: PokemonRepositoryProtocol
    
    required init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPokemonSpecies(id: Int) -> Observable<PokemonSpecies> {
        return repository.getPokemonSpecies(id: id)
    }
}
