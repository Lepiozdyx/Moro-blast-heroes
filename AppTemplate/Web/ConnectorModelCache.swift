import SwiftUI

struct 

AdapterCoordinatorPresenterServiceParser: View {
    
    let url: URL
    var wvm: RunnerParserConverterModelPresenter?
    
    init(url: URL)
    {
        self.url = url
    }
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            RunnerParserConverterModelPresenter(address: url)
        }
    }
}
