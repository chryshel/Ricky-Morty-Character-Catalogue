import Foundation

final class CharacterViewModel: ObservableObject {

    enum State {
        case initial
        case loading
        case display(Character)
        case displayAll(AllCharacters)
        case error
    }
    
    @Published var state: State = .initial
    
    private let characterService: CharacterService
    
    init(characterService: CharacterService) {
        self.characterService = characterService
    }
    
    @MainActor
    func onLoad(id: Int) async {
        state = .loading
        do {
            let character = try await characterService.load(id: id)
            state = .display(character)
        }
        catch {
            state = .error
        }
    }
    
    @MainActor
    func onLoadAll()async {
        state = .loading
        do {
            let characters = try await characterService.loadAll()
            state = .displayAll(characters)
        }
        catch {
            state = .error
        }
    }
    
}
