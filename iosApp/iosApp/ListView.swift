import SwiftUI
import Shared
import Combine

struct ListView: View {
    
    init(app: AppComponent) {
        self.vm = ListViewModel(app: app)
    }
    private var vm: ListViewModel
    
    var body: some View {
        BaseView(vm: vm) { output, input in
            switch onEnum(of: output) {
            case .loading:
                ProgressView()
            case .retry:
                Button(action: { input(ListInput.RetryClicked()) }) {
                    Text("retry")
                }
            case .display(let res):
                List {
                    ForEach(res.list, id: \.id) { item in
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
                        .onTapGesture(count: 1, perform: {
                            input(ListInput.PictureClicked(id: item.id))
                        })
                    }
                }
            }
        }
    }
}

//#Preview {
//    ListView(app: InjectAppComponent(nav: { IosNavigation() }))
//}

class ListViewModel: ScreenToIos<ListInput, ListOutput, ListNavigation, Action_, Result_> {
    
    init(app: AppComponent) {
        super.init(screen: InjectListComponent(appComponent: app).screen)
    }
}
