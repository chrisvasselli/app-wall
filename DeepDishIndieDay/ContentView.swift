import SwiftUI
import DeckUI

struct ContentView: View {
    var body: some View {
        Presenter(deck: self.deck)
    }
}

extension ContentView {
    var deck: Deck {
        Deck(title: "SomeConf 2023") {
            Slide(alignment: .center) {
                Title("Welcome to DeckUI")
            }

            Slide {
                RawView {
                    AppWall(imagesFolder: Bundle.main.url(forResource: "indie-apps", withExtension: nil)!)
                }
            }
        }
    }
}
