import SwiftUI
import Shared
import Combine

struct ListView: View {
    @ObservedObject private var vm = ListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                IfLet (vm.content) { content in
                    switch onEnum(of: content) {
                    case .loading:
                        ProgressView()
                    case .retry:
                        Button(action: { vm.input(inp: ListInput.RetryClicked()) }) {
                            Text("retry")
                        }
                    case .display(let res):
                        List {
                            ForEach(res.list, id: \.id) { item in
                                NavigationLink(destination: DetailsView.init(id: item.id)) {
                                    VStack {
                                        AsyncImage(
                                            url: URL(string: item.image)) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(maxWidth: 300, maxHeight: 100)
                                                case .failure:
                                                    Image(systemName: "photo")
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(maxWidth: 300, maxHeight: 100)
                                        Text(item.name)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dog list")
        }
        .onAppear {
            vm.onAppear()
        }
        .onDisappear(perform: {
            vm.onDisappear()
        })
    }
}

#Preview {
    ListView()
}

class ListViewModel: ObservableObject {
    private let screen = InjectListComponent(appComponent: IOSAppComponent.app).screen

    @Published var content: ListOutput? = nil
    
    private var input: ((ListInput) -> Void)? = nil

    func onAppear() {
        let attach = screen.attach()
        let nav = attach.navigation
        let output = attach.output
        input = attach.input

        Task {
            for await aout in output {
                DispatchQueue.main.async {
                    self.content = aout
                }
            }
        }
        
        Task {
            for await move in nav {
                // subscribed
            }
        }
    }
    
    func input(inp: ListInput) {
        guard let constant = input else { return }
        constant(inp)
    }

    func onDisappear() {
        screen.detach()
    }

    deinit {
        screen.terminate()
    }
}
