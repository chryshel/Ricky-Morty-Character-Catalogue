import Foundation
import Moya

enum CharacterTargetType: TargetType {
    
    case fetchCharacter(id: Int)
    case fetchAllCharacters
    
    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }
    
    var path: String {
        switch self {
        case  let .fetchCharacter(id: id):
            return "/character/\(id)"
        case .fetchAllCharacters:
            return "/character"
        }
    }
    var method: Moya.Method {
        switch self {
        case .fetchCharacter, .fetchAllCharacters:
            return .get
        }
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}


