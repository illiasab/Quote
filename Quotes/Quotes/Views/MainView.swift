import SwiftUI

struct MainView: View {
    @ObservedObject var quotesFetcher = QuotesFetch()

    @State private var searchText = ""

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    // Filtered categories based on searchText
    var filteredCategories: [String] {
        if searchText.isEmpty {
            return Array(quotesFetcher.quotesByCategory.keys)
        } else {
            return Array(quotesFetcher.quotesByCategory.keys).filter {
                $0.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // Filtered quotes based on searchText
    var filteredQuotes: [Quote] {
        if searchText.isEmpty {
            return quotesFetcher.quotes
        } else {
            return quotesFetcher.quotes.filter { quote in
                quote.quote.lowercased().contains(searchText.lowercased()) ||
                quote.author.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.basicBackground.ignoresSafeArea(.all)

                VStack {
                   
                    SearchBar(searchText: $searchText)
                        .padding(.bottom, 20)

                    
                    LazyVGrid(columns: columns, spacing: 20) {
                       
                        ForEach(filteredCategories, id: \.self) { category in
                            if let quotes = quotesFetcher.quotesByCategory[category], !quotes.isEmpty {
                                NavigationLink(destination: QuoteDetailView(category: category, quotesFetcher: quotesFetcher)) {
                                    Text(category.capitalized)
                                        .font(.title)
                                        .foregroundColor(.basicBackground)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(.button)
                                        .cornerRadius(30)
                                        .shadow(radius: 10)
                                }
                            } else {
                                Text("No Quotes Found")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }

                
                        ForEach(filteredQuotes) { quote in
                            NavigationLink(destination: QuoteDetailViewSingle(quote: quote)) {
                                VStack {
                                    Text(quote.quote)
                                        .font(.body)
                                        .foregroundColor(.basicBackground)
                                        .padding()
                                    Text("- \(quote.author)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .background(.button)
                                .cornerRadius(30)
                                .shadow(radius: 10)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
           
            quotesFetcher.fetchQuotes(for: "happiness")
            quotesFetcher.fetchQuotes(for: "success")
            quotesFetcher.fetchQuotes(for: "love")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
