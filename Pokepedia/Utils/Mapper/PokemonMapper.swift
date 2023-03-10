//
//  PokemonMapper.swift
//  Pokepedia
//
//  Created by Rivaldo Fernandes on 13/02/23.
//

import Foundation

final class PokemonMapper {
    static func mapPokemonDetailResponsesToDomain(input pokemonDetailResponses: [PokemonDetailResponse]) -> [Pokemon]{
        
        return pokemonDetailResponses.map { result in
            let image = result.sprites.other.officialArtwork.frontDefault ??
            result.sprites.other.dreamWorld.frontDefault ??
            result.sprites.other.home.frontDefault ?? ""
            
            let newPokemon = Pokemon(
                id: result.id,
                name: result.name,
                image: image,
                height: Float(result.height) / 10.0,
                weight: Float(result.weight) / 10.0,
                baseExp: result.baseExperience,
                baseStat: result.stats.map { statResponse in
                    
                    let newBaseStat = BaseStat(
                        name: statResponse.stat.name,
                        effort: statResponse.effort,
                        value: statResponse.baseStat,
                        url: statResponse.stat.url)
                    
                    return newBaseStat
                    
                },
                moves: result.moves.map { moveResponse in
                    return moveResponse.move.name
                },
                type: result.types.map { typeResponse in
                    return typeResponse.type.name
                },
                abilities: result.abilities.map{ ability in
                    ability.ability.name.capitalized
                }.joined(separator: ", ")
                
            )
            
            return newPokemon
        }
    }
    
    static func mapPokemonSpeciesResponseToDomain(input pokemonSpeciesResponse: PokemonSpeciesResponse) -> PokemonSpecies {
        
        let aboutPokemon = {
            for flavorEntry in pokemonSpeciesResponse.flavorTextEntries {
                if flavorEntry.language.name == "en" {
                    return flavorEntry.flavorText
                        .replacingOccurrences(of: "\n", with: " ")
                        .utf8EncodedString()
                        .replacingOccurrences(of: "\\014", with: " ")
                        .utf8DecodedString()
                }
            }
            return ""
        }()
        
        let genusPokemon = {
            for generaEntry in pokemonSpeciesResponse.genera {
                if generaEntry.language.name == "en" {
                    return generaEntry.genus.capitalized
                }
            }
            return ""
        }()
        
        let eggGroup = pokemonSpeciesResponse.eggGroups.map { itemEgg in
            return itemEgg.name.capitalized
        }.joined(separator: ", ")
        
        let genderRate: String = {
            if pokemonSpeciesResponse.genderRate == -1 {
                return "Genderless"
            } else {
                let female = (Float(pokemonSpeciesResponse.genderRate) / 8.0) * 100
                let male = (Float(8 - pokemonSpeciesResponse.genderRate) / 8.0) * 100
                
                return "Male \(male)%, Female \(female)%"
            }
            
        }()
        
        let newPokemonSpecies = PokemonSpecies(
            id: pokemonSpeciesResponse.id,
            baseHappines: pokemonSpeciesResponse.baseHappiness,
            captureRate: pokemonSpeciesResponse.captureRate,
            color: pokemonSpeciesResponse.color.name,
            about: aboutPokemon,
            genderRate: genderRate,
            genus: genusPokemon,
            growthRate: pokemonSpeciesResponse.growthRate.name.capitalized,
            habitat: pokemonSpeciesResponse.habitat.name.capitalized,
            hatchCounter: pokemonSpeciesResponse.hatchCounter,
            isLegendary: pokemonSpeciesResponse.isLegendary,
            isMythical: pokemonSpeciesResponse.isMythical,
            isBaby: pokemonSpeciesResponse.isBaby,
            shape: pokemonSpeciesResponse.shape.name,
            eggGroups: eggGroup
        )
        return newPokemonSpecies
    }
    
    static func mapPokemonDataToAboutSectionData(pokemon: Pokemon, pokemonSpecies: PokemonSpecies) -> [AboutCellModel] {
        var dataAboutCellModel: [AboutCellModel] = []
        
        
        var speciesItemCellModel: [ItemCellModel] = []
        speciesItemCellModel.append(ItemCellModel(title: "Genus", value: pokemonSpecies.genus))
        speciesItemCellModel.append(ItemCellModel(title: "Height", value: "\(pokemon.height) m"))
        speciesItemCellModel.append(ItemCellModel(title: "Weight", value: "\(pokemon.weight) kg"))
        speciesItemCellModel.append(ItemCellModel(title: "Abilities", value: pokemon.abilities))
        speciesItemCellModel.append(ItemCellModel(title: "Status", value: pokemonSpecies.isLegendary ? "Legendary" : pokemonSpecies.isMythical ? "Mythical" : "Common"))
        speciesItemCellModel.append(ItemCellModel(title: "Habitat", value: pokemonSpecies.habitat))
        let speciesCellModel = AboutCellModel(name: "Species", item: speciesItemCellModel)
        
        var physicalItemCellModel: [ItemCellModel] = []
        physicalItemCellModel.append(ItemCellModel(title: "Growth Rate", value: pokemonSpecies.growthRate))
        physicalItemCellModel.append(ItemCellModel(title: "Hatch Counter", value: String(pokemonSpecies.hatchCounter)))
        physicalItemCellModel.append(ItemCellModel(title: "Base Happines", value: String(pokemonSpecies.baseHappines)))
        physicalItemCellModel.append(ItemCellModel(title: "Base Experience", value: String(pokemon.baseExp)))
        physicalItemCellModel.append(ItemCellModel(title: "Capture Rate", value: String(pokemonSpecies.captureRate)))
        let physicalCellModel = AboutCellModel(name: "Physical", item: physicalItemCellModel)
        
        var breedingItemCellModel: [ItemCellModel] = []
        breedingItemCellModel.append(ItemCellModel(title: "Gender", value: pokemonSpecies.genderRate))
        breedingItemCellModel.append(ItemCellModel(title: "Egg Groups", value: pokemonSpecies.eggGroups))
        breedingItemCellModel.append(ItemCellModel(title: "Baby Pokemon", value: pokemonSpecies.isBaby ? "Yes" : "No"))
        let breedingCellModel = AboutCellModel(name: "Breeding", item: breedingItemCellModel)
        
        dataAboutCellModel.append(speciesCellModel)
        dataAboutCellModel.append(physicalCellModel)
        dataAboutCellModel.append(breedingCellModel)
        
        return dataAboutCellModel
    }
    
}
