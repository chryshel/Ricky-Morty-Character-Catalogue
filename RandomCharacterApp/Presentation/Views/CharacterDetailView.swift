import SwiftUI

struct CharacterDetailView: View {
    let character: Characters

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: character.image))
            Text("Name: \(character.name)")
            Text("Gender: \(character.gender)")
            Text("Origin: \(character.origin.name)")
            Spacer()
            // Add more character details here
        }
        .padding()
        .navigationTitle(character.name)
    }
}
