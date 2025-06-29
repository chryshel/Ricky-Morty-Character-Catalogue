import Moya
import Foundation

protocol CharacterService {
    func load(id: Int) async throws -> Character
    func loadAll() async throws -> AllCharacters
}

class RemoteCharacterService: CharacterService {
    
    private let provider: MoyaProvider<CharacterTargetType>
    
    init(provider: MoyaProvider<CharacterTargetType>) {
        self.provider = provider
    }
    
    enum Error: Swift.Error, CaseIterable {
        case timoutError
        case invalidJsonError
        case invalidJsonFormat
        case serverError
        case characterNotFoundError
    }
    
    func load(id: Int) async throws -> Character {
        return try await withCheckedThrowingContinuation { continuation in
            load(id: id) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func loadAll() async throws -> AllCharacters {
        return try await withCheckedThrowingContinuation { continuation in
            loadAll() { result in
                continuation.resume(with: result)
            }
        }
    }
    
    private func load(id:Int, completion: @escaping (Result<Character,Error>) -> Void){
        provider.request(.fetchCharacter(id: id)) { [weak self] result in
            guard let self else { return }
            switch result{
            case let .success(res):
                completion(self.mapSingleCharacters(res))
            case .failure:
                completion(.failure(Error.timoutError))
            }
            
        }
    }
    
    private func loadAll(completion: @escaping (Result<AllCharacters,Error>) -> Void){
        provider.request(.fetchAllCharacters) { [weak self] result in
            guard let self else { return }
            switch result{
            case let .success(res):
                completion(self.mapMultipleCharacters(res))
            case .failure:
                print("erro")
            }
        }
    }
    
    private func mapSingleCharacters(_ res: Moya.Response) -> Result<Character,Error>{
        if res.statusCode == 201 {
            return .failure(Error.characterNotFoundError)
            
        }
        else if res.statusCode == 500 {
            return .failure(Error.serverError)
        } else {
            print(res.request?.url ?? "")
            do{
                let character = try JSONDecoder().decode(Character.self, from: res.data)
                return .success(character)
            }catch{
                return .failure(Error.invalidJsonError)
            }
        }
    }
    
    private func mapMultipleCharacters(_ res: Moya.Response) -> Result<AllCharacters,Error>{
        
        if res.statusCode == 201 {
            return .failure(Error.characterNotFoundError)
        }
        else if res.statusCode == 500 {
            return .failure(Error.serverError)
        } else {
            print(res.request?.url ?? "")
            do{
                if let jsonString = String(data: res.data, encoding: .utf8) {
                    print("Raw JSON: \(jsonString)")
                }
                let characters = try JSONDecoder().decode(AllCharacters.self, from: res.data)
                return .success(characters)
            } catch {
                return .failure(Error.invalidJsonError)
            }
        }
    }
}
