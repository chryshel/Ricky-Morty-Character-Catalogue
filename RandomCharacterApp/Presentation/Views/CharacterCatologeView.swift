import SwiftUI

struct CharacterCatologeView: View {
    @State private var searchQuery = ""
    @StateObject private var viewModel: CharacterViewModel
    
    init(service: CharacterService) {
        _viewModel = StateObject(wrappedValue: CharacterViewModel(characterService: service))
    }

    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Rick & Morty Catologue")
                .onAppear {
                    Task {
                        await viewModel.onLoadAll()// example ID
                    }
                }
        }
    }
    
    @ViewBuilder
        private var content: some View {
            switch viewModel.state {
            case .initial, .loading:
                ProgressView("Loading...")
            case .display(let character):
                Text("Character: \(character.name)")
            case .displayAll(let characters):
                List(filterCharacters(from: characters.results), id: \.id) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        HStack(spacing: 12) {
                            CircularRemoteImageView(url: URL(string: character.image), size: 40)
                            Text("Character: \(character.name)")
                        }
                    }
                }
                .searchable(text: $searchQuery, prompt: "Search by name")
                .refreshable {
                    await viewModel.onLoadAll()
                    searchQuery = ""
                }
            
            case .error:
                Text("An error occurred.")
            
            }
        }
    
    private func filterCharacters(from results: [Characters]) -> [Characters] {
        if searchQuery.isEmpty {
            return results
        }
        else {
            return results.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}

