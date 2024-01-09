import SwiftUI
import Shared

struct DetailsView: View {
    
    @ObservedObject private var vm : DetailsViewModel
    
    init(id: String) {
        self.vm = DetailsViewModel(imageId: id)
    }
    
    var body: some View {
        VStack {
            IfLet (vm.content) { content in
                switch onEnum(of: content.uiState) {
                case.loading:
                    ProgressView()
                case .retry:
                    Button(action: { vm.input(inp: DetailsInput.RetryClicked()) }) {
                        Text("retry")
                    }
                case .display(let res):
                    Text(res.name)
                    AsyncImage(
                        url: URL(string: res.image)) { phase in
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
                    Text(res.origin)
                    Text(res.temperament)
                    Text(res.wikiUrl)
                    Spacer()
                }
            }
        }
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisappear() }
    }
}

#Preview {
    DetailsView(id: "SkmRJl9VQ")
}

class DetailsViewModel: ObservableObject {
    private let imageId: String

    init(imageId: String) {
        self.imageId = imageId
    }
    
    private lazy var screen = InjectDetailsComponent(appComponent: IOSAppComponent.app, imageId: imageId).screen

    @Published var content: DetailsOutput? = nil
    
    private var input: ((DetailsInput) -> Void)? = nil

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
    
    func input(inp: DetailsInput) {
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
