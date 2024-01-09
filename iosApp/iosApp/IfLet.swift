import SwiftUI

struct IfLet<Value, Content>: View where Content: View {

    let value: Value?
    let contentBuilder: (Value) -> Content

    init(_ optionalValue: Value?, @ViewBuilder whenPresent contentBuilder: @escaping (Value) -> Content) {
        self.value = optionalValue
        self.contentBuilder = contentBuilder
    }

    var body: some View {
        Group {
            if value != nil {
                contentBuilder(value!)
            } else {
                EmptyView()
            }
        }
    }
}
