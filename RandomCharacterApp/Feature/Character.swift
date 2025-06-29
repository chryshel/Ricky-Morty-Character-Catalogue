import Foundation

struct Character: Decodable, Equatable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: URL
}
