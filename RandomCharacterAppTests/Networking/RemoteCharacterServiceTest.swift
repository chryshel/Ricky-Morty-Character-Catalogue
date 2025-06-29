import XCTest
import Moya
@testable import RandomCharacterApp

// success -> fecth character
// success -> not found
// success -> different format JSON
// success -> server error
// success -> empty JSON ✅
// failure -> timeout - ✅


final class RemoteCharacterServiceTest: XCTestCase {
    
    func test_load_returnSuccess_onValidResponse() async {
        let sut = setupSUT(sampleResponseClosure: { .networkResponse(200, self.validJsonFormatData())})
        
        do {
            let character = try await sut.load(id: 1)
            XCTAssertEqual(character.id, 1)
            XCTAssertEqual(character.name, "Rick Sanchez")
            XCTAssertEqual(character.status, "Alive")
            XCTAssertEqual(character.species, "Human")
            XCTAssertEqual(character.gender, "Male")
            XCTAssertEqual(character.image, URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
        }catch {
            XCTFail("unexpected valid json to decode, got error \(error)")
        }
    }

    func test_load_returnSuccess_onNotFound() async {
        
        let sut = setupSUT(sampleResponseClosure: { .networkResponse(201, self.notFoundCharacterJsonData())})
        
        do {
            _ = try await sut.load(id: 1)
        } catch {
            if let error = error as? RemoteCharacterService.Error {
                XCTAssertEqual(error, RemoteCharacterService.Error.characterNotFoundError)
            }else {
                XCTFail("expecting Not Found Character Error but got \(error)instead")
            }
            
        }
    }
    
    func test_load_returnTimeoutError_onNetworkError() async{
        let sut = setupSUT( sampleResponseClosure: { .networkError(NSError())})
        
        do {
            _ = try await sut.load(id: 1)
        }catch{
            if let error = error as? RemoteCharacterService.Error {
                XCTAssertEqual(error, RemoteCharacterService.Error.timoutError)
            }else {
                XCTFail("expecting TimeoutError but got \(error)instead")
            }
            
        }
        
    }
    
    func test_load_returnErrorOnEmptyJsonData() async {
        
        let sut = setupSUT(sampleResponseClosure: { .networkResponse(200, self.emptyJsonData())})
        
        do {
            _ = try await  sut.load(id: 1)
        }catch{
            if let error = error as? RemoteCharacterService.Error {
                XCTAssertEqual(error, RemoteCharacterService.Error.invalidJsonError)
            }else {
                XCTFail("expecting invalidJsonError but got \(error)instead")
            }
            
        }
    }
    
    func test_load_returnErrorOnDecodingFailure() async {
        
        let sut = setupSUT( sampleResponseClosure: { .networkResponse(200, self.invalidJsonFormatData())})
        
        do {
            _ = try await  sut.load(id: 1)
        }catch{
            if let error = error as? RemoteCharacterService.Error {
                XCTAssertEqual(error, RemoteCharacterService.Error.invalidJsonError)
            }else {
                XCTFail("expecting serverError but got \(error)instead")
            }
            
        }
    }
    
    func test_load_returnErrorOnServerError() async {
        
        let sut = setupSUT( sampleResponseClosure: { .networkResponse(500, "".data(using: .utf8)!)})
        
        do {
            _ = try await  sut.load(id: 1)
        }catch{
            if let error = error as? RemoteCharacterService.Error {
                XCTAssertEqual(error, RemoteCharacterService.Error.serverError)
            }else {
                XCTFail("expecting serverError but got \(error)instead")
            }
            
        }
    }
    
    
    private func setupSUT(sampleResponseClosure: @escaping Endpoint.SampleResponseClosure) -> RemoteCharacterService {
        let customEndpointClosure = { (target: CharacterTargetType) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: sampleResponseClosure,
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        
        let stubbingProvider = MoyaProvider<CharacterTargetType>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let sut = RemoteCharacterService(provider: stubbingProvider)
        
        return sut
    }
    
    private func invalidJsonFormatData() -> Data {
        let invalidJsonData = """
        {
        "id": "1"
        "name": {
            "first" : "Rick",
            "last" : "Sanchez"
        }
        "status": "Alive",
        "species": "Human",
        "type": "",
        "gender": "Male",
        "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        }
        """.data(using: .utf8)!
        
        return invalidJsonData
    }
    
    private func validJsonFormatData() -> Data {
        let validJsonData = """
                {
                   "id":1,
                   "name":"Rick Sanchez",
                   "status":"Alive",
                   "species":"Human",
                   "type":"",
                   "gender":"Male",
                   "origin":{
                      "name":"Earth (C-137)",
                      "url":"https://rickandmortyapi.com/api/location/1"
                   },
                   "location":{
                      "name":"Citadel of Ricks",
                      "url":"https://rickandmortyapi.com/api/location/3"
                   },
                   "image":"https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                   "episode":[
                      "https://rickandmortyapi.com/api/episode/1",
                      "https://rickandmortyapi.com/api/episode/2",
                      "https://rickandmortyapi.com/api/episode/3",
                      "https://rickandmortyapi.com/api/episode/4",
                      "https://rickandmortyapi.com/api/episode/5",
                      "https://rickandmortyapi.com/api/episode/6",
                      "https://rickandmortyapi.com/api/episode/7",
                      "https://rickandmortyapi.com/api/episode/8",
                      "https://rickandmortyapi.com/api/episode/9",
                      "https://rickandmortyapi.com/api/episode/10",
                      "https://rickandmortyapi.com/api/episode/11",
                      "https://rickandmortyapi.com/api/episode/12",
                      "https://rickandmortyapi.com/api/episode/13",
                      "https://rickandmortyapi.com/api/episode/14",
                      "https://rickandmortyapi.com/api/episode/15",
                      "https://rickandmortyapi.com/api/episode/16",
                      "https://rickandmortyapi.com/api/episode/17",
                      "https://rickandmortyapi.com/api/episode/18",
                      "https://rickandmortyapi.com/api/episode/19",
                      "https://rickandmortyapi.com/api/episode/20",
                      "https://rickandmortyapi.com/api/episode/21",
                      "https://rickandmortyapi.com/api/episode/22",
                      "https://rickandmortyapi.com/api/episode/23",
                      "https://rickandmortyapi.com/api/episode/24",
                      "https://rickandmortyapi.com/api/episode/25",
                      "https://rickandmortyapi.com/api/episode/26",
                      "https://rickandmortyapi.com/api/episode/27",
                      "https://rickandmortyapi.com/api/episode/28",
                      "https://rickandmortyapi.com/api/episode/29",
                      "https://rickandmortyapi.com/api/episode/30",
                      "https://rickandmortyapi.com/api/episode/31",
                      "https://rickandmortyapi.com/api/episode/32",
                      "https://rickandmortyapi.com/api/episode/33",
                      "https://rickandmortyapi.com/api/episode/34",
                      "https://rickandmortyapi.com/api/episode/35",
                      "https://rickandmortyapi.com/api/episode/36",
                      "https://rickandmortyapi.com/api/episode/37",
                      "https://rickandmortyapi.com/api/episode/38",
                      "https://rickandmortyapi.com/api/episode/39",
                      "https://rickandmortyapi.com/api/episode/40",
                      "https://rickandmortyapi.com/api/episode/41",
                      "https://rickandmortyapi.com/api/episode/42",
                      "https://rickandmortyapi.com/api/episode/43",
                      "https://rickandmortyapi.com/api/episode/44",
                      "https://rickandmortyapi.com/api/episode/45",
                      "https://rickandmortyapi.com/api/episode/46",
                      "https://rickandmortyapi.com/api/episode/47",
                      "https://rickandmortyapi.com/api/episode/48",
                      "https://rickandmortyapi.com/api/episode/49",
                      "https://rickandmortyapi.com/api/episode/50",
                      "https://rickandmortyapi.com/api/episode/51"
                   ],
                   "url":"https://rickandmortyapi.com/api/character/1",
                   "created":"2017-11-04T18:48:46.250Z"
                }
        """.data(using: .utf8)!
        
        return validJsonData
    }
    
    private func emptyJsonData() -> Data {
        return "".data(using: .utf8)!
    }
    
    private func notFoundCharacterJsonData() -> Data {
        let characterNotFoundJsonData = """
        {
        "error": "Character not found",
        }e
        """.data(using: .utf8)!
        
        return characterNotFoundJsonData
    }
}
