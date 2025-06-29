import XCTest
import Combine
@testable import RandomCharacterApp


final class CharacterViewModelTest:XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()

    func test_init_doesNotLoadCharacter() {
        let (_, service) = makeSUT()
        
        XCTAssertEqual(service.loadUserCallCount,0)
    }
    
    func test_onLoad_loadsCharacterAsync() async {
        let (sut, service) = makeSUT()
        
        await sut.onLoad(id: 1)
        
        XCTAssertEqual(service.loadUserCallCount,1)
    }
    
    func test_onLoad_showsErrorAsync() async {
        
        let errors = RemoteCharacterService.Error.allCases
        
        for (index, error) in errors.enumerated() {
            let sut = makeSUT(result: .failure(error))
            var receivedStates = [CharacterViewModel.State]()
            sut.$state.dropFirst().sink { state  in
                receivedStates.append(state)
            }.store(in: &cancellables)
            
            await sut.onLoad(id: 1)
            XCTAssertEqual(receivedStates, [.loading, .error], "Fail at \(index) with error: \(error)")
           
        }
      
    }
    
    func test_onLoad_showsCharacterAsync() async {
        let expectedCharacter = anyCharacter()
        let sut = makeSUT(result: .success(expectedCharacter))
        var receivedStates = [CharacterViewModel.State]()
        sut.$state.dropFirst().sink { state  in
            receivedStates.append(state)
        }.store(in: &cancellables)
        
        await sut.onLoad(id: 1)
    
        XCTAssertEqual(receivedStates, [.loading, .display(expectedCharacter)])
        
    }
    
    private func makeSUT() -> (sut: CharacterViewModel, service: CharacterServiceSpy){
        let service = CharacterServiceSpy()
        let sut = CharacterViewModel(characterService: service)
        
        return (sut, service)
    }
    
    private func makeSUT(result: Result<Character, Error>) -> CharacterViewModel {
        let service = CharacterServiceStub(result: result)
        let sut = CharacterViewModel(characterService: service)
        
        return sut
    }
    
    private func anyCharacter() -> Character {
        return Character(id: 0, name: "",status: "",species: "", gender: "", image:URL(string: "www.google.com")!)
    }
    
    private final class CharacterServiceStub: CharacterService {
        func loadAll() async throws -> RandomCharacterApp.AllCharacters {
            <#code#>
        }
        
       
        private let result: Result<Character, Error>
        
        init(result: Result<Character, Error>) {
            self.result = result
        }
        
        func load(id: Int) async throws ->  Character {
            return try result.get()
        }
    }
    
    private final class CharacterServiceSpy: CharacterService {
        func loadAll() async throws -> RandomCharacterApp.AllCharacters {
            <#code#>
        }
        
        private(set) var loadUserCallCount = 0
        
        func load(id: Int) async throws ->  Character {
            loadUserCallCount += 1
            return Character(id: 0, name: "",status: "",species: "", gender: "", image:URL(string: "www.google.com")!)
        }
        
        
    }
}
