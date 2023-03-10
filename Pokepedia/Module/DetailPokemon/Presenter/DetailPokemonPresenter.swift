//
//  DetailPokemonPresenter.swift
//  Pokepedia
//
//  Created by Rivaldo Fernandes on 14/02/23.
//

import Foundation
import RxSwift

protocol DetailPokemonPresenterProtocol {
    var router: DetailPokemonRouterProtocol? { get set}
    var interactor: DetailPokemonUseCase? { get set }
    var detailPokemonView: DetailPokemonViewProtocol? { get set }
    
    var isLoadingData: Bool { get set}
    func getPokemonSpecies(id: Int)
    
    func getPokemon(with pokemon: Pokemon)
}

class DetailPokemonPresenter: DetailPokemonPresenterProtocol {
    func getPokemon(with pokemon: Pokemon) {
        detailPokemonView?.updatePokemon(with: pokemon)
        getPokemonSpecies(id: pokemon.id)
    }
    
    var router: DetailPokemonRouterProtocol?
    
    var interactor: DetailPokemonUseCase?
    
    var detailPokemonView: DetailPokemonViewProtocol?
    
    var isLoadingData: Bool = false
    
    private let disposeBag = DisposeBag()
    
    func getPokemonSpecies(id: Int) {
        isLoadingData = true
        
        interactor?.getPokemonSpecies(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe{[weak self] pokemonSpeciesResult in
                self?.detailPokemonView?.updatePokemonSpecies(with: pokemonSpeciesResult)
            } onError: { error in
                self.detailPokemonView?.updatePokemonSpecies(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
    }
}
