import SwiftUI

let iconSize = 72
let rowCount = 12
let sectionCount = 12
let duration: CGFloat = 300

struct AppIcon: Identifiable {
    let id = UUID()
    var url: URL
    let image: NSImage
    
    init(url: URL) {
        self.url = url
        self.image = NSImage(byReferencing: url)
    }
}

struct AppWall: View {
    var imagesFolder: URL
    var icons: [AppIcon]
    @State var offset: CGFloat = 0
    
    init(imagesFolder: URL) {
        self.imagesFolder = imagesFolder
        let imageURLs = try! FileManager.default.contentsOfDirectory(at: imagesFolder, includingPropertiesForKeys: nil).filter { $0.pathExtension == "jpg" }
        
        var icons: [AppIcon] = []
        for _ in 0..<16 {
            let shuffledURLs = imageURLs.shuffled()
            icons.append(contentsOf: shuffledURLs.map { AppIcon(url: $0) })
        }
        
        self.icons = icons
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ForEach(0..<sectionCount, id: \.self) { sectionIndex in
                    let countPerSection = icons.count / sectionCount
                    let start = sectionIndex * countPerSection
                    let end = (sectionIndex + 1) * countPerSection
                    WallSection(icons: Array(icons[start..<end]))
                        .offset(CGSize(width: sectionIndex % 2 == 0 ? offset : -proxy.size.width - offset, height: 0))
                }
            }
            .onAppear {
                offset = -proxy.size.width + CGFloat(iconSize)
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true).delay(-duration / 10)) {
                    offset = 0
                }
            }
        }
        .transition(.identity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppWall(imagesFolder: Bundle.main.url(forResource: "indie-apps", withExtension: nil)!)
            .frame(width: 400, height: 600)
    }
}

struct WallSection: View {
    let rows = Array(repeating: GridItem(.fixed(72)), count: rowCount / sectionCount)
    var icons: [AppIcon]

    var body: some View {
        LazyHGrid(rows: rows) {
            ForEach(icons) { icon in
                Image(nsImage: icon.image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 11, height: 11)))
            }
        }
    }
}
