import SwiftUI
import Shared

struct DetailsView: View {
    
    private var vm : DetailsViewModel
    
    init(id: String, app: AppComponent) {
        self.vm = DetailsViewModel(imageId: id, app: app)
    }
    
    var body: some View {
        BaseView(vm: vm) { output, input in
            switch onEnum(of: output.uiState) {
            case.loading:
                ProgressView()
            case .retry:
                Button(action: { input(DetailsInput.RetryClicked()) }) {
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
}

//#Preview {
//    DetailsView(id: "SkmRJl9VQ", app: InjectAppComponent(nav: { IosNavigation() }))
//}

class DetailsViewModel: ScreenToIos<DetailsInput, DetailsOutput, DetailsNavigation, Action, Result> {
    
    init(imageId: String, app: AppComponent) {
        super.init(screen: InjectDetailsComponent(appComponent: app, imageId: imageId).screen )
    }
}
