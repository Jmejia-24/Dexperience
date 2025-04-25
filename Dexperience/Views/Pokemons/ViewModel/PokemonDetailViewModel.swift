//
//  PokemonDetailViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/12/25.
//

import Foundation

final class PokemonDetailViewModel<R: PokemonsRouter> {

    // MARK: - Properties

    private let router: R
    private let api: PokemonsRepository
    private let pokemonPath: String?

    let containerTopConstraintConstant: CGFloat = 140
    let headerTopConstraintConstant: CGFloat = 30
    var isHeaderHidden = false
    
    var pokemon: Pokemon?
    var pokemonType: PokemonType?
    var flavorText: String?
    var currentTab: Tab = .stats
    var pokemonMoves = [LearnableMove]()
    var evolutions: [Evolution] = []
    var statDisplays: [StatDisplay] = []
    var breedingInfo: BreedingInfo?
    var captureInfo: CaptureInfo?

    // MARK: - Initializers

    init(router: R, api: PokemonsRepository = APIManager(), pokemonPath: String?) {
        self.router = router
        self.api = api
        self.pokemonPath = pokemonPath
    }

    // MARK: - Data Fetching

    @MainActor
    func fetchDetails() async throws {
        guard let pokemonPath else { return }

        let pokemonResponse = try await api.fetchPokemon(from: pokemonPath)

        pokemon = pokemonResponse

        if let typeName = pokemonResponse.types?.first?.type?.name {
            pokemonType = PokemonType(rawValue: typeName)
        }

        pokemonMoves = extractLearnableMoves(from: pokemonResponse.moves)
        statDisplays = extractStats(from: pokemonResponse.stats)
    }

    @MainActor
    func fetchSpecie() async throws {
        guard let speciePath = pokemon?.species?.url?.lastPathComponent else { return }

        let specieResponse = try await api.fetchSpecie(from: speciePath)

        flavorText = specieResponse.flavorTextEntries?
            .first(where: {
                $0.language?.name == .en && $0.version?.name == .alphaSapphire
            })?
            .flavorText

        breedingInfo = extractBreedingInfo(from: specieResponse)
        captureInfo = extractCaptureInfo(from: specieResponse)

        if let evolutionPath = specieResponse.evolutionChain?.url?.lastPathComponent {
            let evolutionChainResponse = try await api.fetchEvolutionChain(from: evolutionPath)

            var parsedEvolutions: [Evolution] = []
            await parseEvolutions(from: evolutionChainResponse.chain, evolutions: &parsedEvolutions)

            evolutions = parsedEvolutions.sorted {
                if $0.isVariant != $1.isVariant {
                    return !$0.isVariant
                } else {
                    return ($0.minLevel ?? 0) < ($1.minLevel ?? 0)
                }
            }
        }
    }
}

private extension PokemonDetailViewModel {

    func extractLearnableMoves(from moves: [MoveElement]?) -> [LearnableMove] {
        guard let moves else { return [] }

        let version = "omega-ruby-alpha-sapphire"

        return moves
            .filter { moveElement in
                guard let versionDetails = moveElement.versionGroupDetails else { return false }

                return versionDetails.contains {
                    $0.moveLearnMethod?.name == "level-up" &&
                    $0.versionGroup?.name == version
                }
            }
            .compactMap { moveElement in
                guard
                    let move = moveElement.move,
                    let versionDetails = moveElement.versionGroupDetails,
                    let detail = versionDetails.first(where: {
                        $0.moveLearnMethod?.name == "level-up" &&
                        $0.versionGroup?.name == version
                    }),
                    let level = detail.levelLearnedAt
                else {
                    return nil
                }

                return LearnableMove(move: move, level: level)
            }
            .sorted { $0.level < $1.level }
    }

    @MainActor
    func parseEvolutions(from chain: EvolutionChain?, evolutions: inout [Evolution]) async {
        guard let fromName = chain?.species?.name else { return }

        for evolution in chain?.evolvesTo ?? [] {
            guard let toName = evolution.species?.name else { continue }

            let detail = evolution.evolutionDetails?.first

            async let fromPokemon = api.fetchPokemon(from: fromName)
            async let toPokemon = api.fetchPokemon(from: toName)

            guard
                let fromPoke = try? await fromPokemon,
                let toPoke = try? await toPokemon,
                let toSpeciesPath = toPoke.species?.url?.lastPathComponent,
                let toSpecies = try? await api.fetchSpecie(from: toSpeciesPath)
            else { continue }

            evolutions.append(
                Evolution(
                    from: fromName.capitalized,
                    to: toName.capitalized,
                    minLevel: detail?.minLevel,
                    isVariant: false,
                    fromSprite: fromPoke.sprites?.other?.officialArtwork?.frontDefault,
                    toSprite: toPoke.sprites?.other?.officialArtwork?.frontDefault
                )
            )

            let variants = toSpecies.varieties?.filter { $0.isDefault == false } ?? []

            for variant in variants {
                guard
                    let variantName = variant.pokemon?.name,
                    let variantPokemon = try? await api.fetchPokemon(from: variantName)
                else { continue }

                evolutions.append(
                    Evolution(
                        from: toName.capitalized,
                        to: variantName.capitalized,
                        minLevel: nil,
                        isVariant: true,
                        fromSprite: toPoke.sprites?.other?.officialArtwork?.frontDefault,
                        toSprite: variantPokemon.sprites?.other?.officialArtwork?.frontDefault
                    )
                )
            }

            await parseEvolutions(from: evolution, evolutions: &evolutions)
        }
    }

    func extractStats(from stats: [PokemonStat]?) -> [StatDisplay] {
        guard let stats else { return [] }

        return stats.compactMap { stat in
            guard let name = stat.stat?.name,
                  let type = PokemonStatType(rawValue: name),
                  let value = stat.baseStat else { return nil }

            return StatDisplay(value: value, type: type)
        }
    }

    func extractBreedingInfo(from species: Specie) -> BreedingInfo {
        let eggGroups = species.eggGroups?.compactMap { $0.name?.formatted } ?? []

        let hatchCycles = species.hatchCounter ?? 0
        let hatchSteps = hatchCycles * 255
        let genderRate = species.genderRate ?? -1
        let isGenderless = genderRate == -1

        let (femaleRate, maleRate): (Double?, Double?)

        if isGenderless {
            femaleRate = nil
            maleRate = nil
        } else {
            femaleRate = Double(genderRate) * 12.5
            maleRate = 100 - (femaleRate ?? 0)
        }

        let genderRatio = GenderRatio(male: maleRate ?? 0, female: femaleRate ?? 0)

        return BreedingInfo(
            eggGroups: eggGroups,
            hatchSteps: hatchSteps,
            hatchCycles: hatchCycles,
            genderRatio: genderRatio,
            isGenderless: isGenderless
        )
    }

    func extractCaptureInfo(from species: Specie) -> CaptureInfo {
        let habitat = species.habitat?.name?.formatted
        let generation = species.generation?.name?.formatted
        let captureRate = species.captureRate ?? 0

        return CaptureInfo(
            habitat: habitat,
            generation: generation,
            captureRate: captureRate
        )
    }
}
