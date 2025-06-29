import XCTest
import Moya
@testable import RandomCharacterApp

final class RCSIntergrationTests: XCTestCase {
   
    func test_returnsCorrectCharacter() async {
        let provider = MoyaProvider<CharacterTargetType>()
        let sut = RemoteCharacterService(provider: provider)
        
        do{
            let character = try await sut.load(id: 1)
            XCTAssertEqual(character.id, 1)
            XCTAssertEqual(character.name, "Rick Sanchez")
            XCTAssertEqual(character.status, "Alive")
            XCTAssertEqual(character.species, "Human")
            XCTAssertEqual(character.gender, "Male")
            XCTAssertEqual(character.image, URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
        }catch{
            XCTFail("expecting to get a real response instead got \(error)")
        }
    }
}
