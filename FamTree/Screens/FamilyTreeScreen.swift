import SwiftUI
import SwiftData

struct FamilyTreeScreen: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Person> { $0.isYou == true }) private var you: [Person]

    @State private var showForm = false
    @State private var showDetail = false

    private let nodes: [Node] = [
        Node(id: UUID(), title: "（あなた）", pos: CGPoint(x: 0.50, y: 0.42), isYou: true),
        Node(id: UUID(), title: "父", pos: CGPoint(x: 0.30, y: 0.24)),
        Node(id: UUID(), title: "母", pos: CGPoint(x: 0.70, y: 0.24))
    ]

    var body: some View {
        ZStack {
            LeafZoomBackground().ignoresSafeArea()
            GeometryReader { geo in
                ZStack {
                    ForEach(nodes) { node in
                        Button {
                            guard node.isYou else { return }
                            if you.first != nil { showDetail = true } else { showForm = true }
                        } label: {
                            PersonChip(title: node.title)
                        }
                        .buttonStyle(.plain)
                        .position(x: node.pos.x * geo.size.width,
                                  y: node.pos.y * geo.size.height)
                    }
                }
                .padding(.top, 16)
            }
        }
        .sheet(isPresented: $showForm) {
            NavigationStack { PersonFormView() }
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showDetail) {
            if let me = you.first {
                NavigationStack { PersonDetailView(person: me) }
                    .presentationDetents([.medium, .large])
            }
        }
    }
}
