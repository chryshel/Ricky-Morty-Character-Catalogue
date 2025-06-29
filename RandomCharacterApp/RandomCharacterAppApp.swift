
import SwiftUI
import Moya

@main
struct RandomCharacterAppApp: App {
    var body: some Scene {
        WindowGroup {
            let provider = MoyaProvider<CharacterTargetType>()
            let service = RemoteCharacterService(provider: provider)
            CharacterCatologeView(service: service)        }
    }
}
