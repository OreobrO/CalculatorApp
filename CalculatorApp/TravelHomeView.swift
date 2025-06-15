import SwiftUI

// MARK: - Models
struct Travel: Identifiable, Hashable {
    let id = UUID()
    let destination: String
    let date: String
    let imageName: String
    let peopleCount: Int
    let description: String
    let budget: Double
    let currency: String
}

// MARK: - View Models
final class TravelViewModel: ObservableObject {
    @Published var travels: [Travel] = [
        Travel(
            destination: "도쿄 여행",
            date: "23.06.03 - 23.06.07",
            imageName: "tokyo",
            peopleCount: 3,
            description: "도쿄 디즈니랜드, 시부야, 하라주쿠 등 도쿄의 주요 관광지를 둘러보는 여행",
            budget: 2000000,
            currency: "JPY"
        ),
        Travel(
            destination: "호주 여행",
            date: "22.09.23 - 22.10.27",
            imageName: "sydney",
            peopleCount: 2,
            description: "시드니 오페라하우스, 그레이트 배리어 리프, 울루루 등 호주의 자연과 문화를 경험하는 여행",
            budget: 5000000,
            currency: "AUD"
        )
    ]
    
    func addTravel(_ travel: Travel) {
        travels.append(travel)
    }
}

// MARK: - Views
struct TravelHomeView: View {
    @StateObject private var viewModel = TravelViewModel()
    @State private var showingAddTravel = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.travels) { travel in
                        NavigationLink {
                            TravelDetailView(travel: travel)
                        } label: {
                            TravelCardView(travel: travel)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("여행")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddTravel = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddTravel) {
            AddTravelView(viewModel: viewModel)
        }
    }
}

struct TravelCardView: View {
    let travel: Travel
    
    var body: some View {
        ZStack {
            Image(travel.imageName)
                .resizable()
                .scaledToFill()
                .clipped()
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(travel.destination)
                        .font(.title3)
                        .bold()
                    Text(travel.date)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Spacer()
                        .frame(height: 8)
                    HStack(spacing: 8) {
                        Image(systemName: "person.2.fill")
                        Text("\(travel.peopleCount)")
                    }
                    .font(.caption2)
                    .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .frame(height: 104)
        .cornerRadius(26)
    }
}

struct TravelDetailView: View {
    let travel: Travel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(travel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(travel.description)
                        .font(.body)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(travel.date)
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("\(travel.peopleCount)명")
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        Text("예산: \(String(format: "%.0f", travel.budget)) \(travel.currency)")
                    }
                    .font(.subheadline)
                }
                .padding()
            }
        }
        .navigationTitle(travel.destination)
    }
}

struct AddTravelView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TravelViewModel
    
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var peopleCount = 2
    @State private var description = ""
    @State private var budget = ""
    @State private var currency = "KRW"
    
    private let currencies = ["KRW", "USD", "JPY", "EUR", "AUD"]
    
    var body: some View {
        NavigationView {
            Form {
                travelInfoSection
                detailInfoSection
            }
            .navigationTitle("새 여행 추가")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { saveTravel() }
                        .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var travelInfoSection: some View {
        Section(header: Text("여행 정보")) {
            TextField("여행지", text: $destination)
            DatePicker("시작일", selection: $startDate, displayedComponents: .date)
            DatePicker("종료일", selection: $endDate, displayedComponents: .date)
            Stepper("인원: \(peopleCount)명", value: $peopleCount, in: 1...10)
        }
    }
    
    private var detailInfoSection: some View {
        Section(header: Text("상세 정보")) {
            TextEditor(text: $description)
                .frame(height: 100)
            TextField("예산", text: $budget)
                .textContentType(.none)
            Picker("통화", selection: $currency) {
                ForEach(currencies, id: \.self) { currency in
                    Text(currency)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !destination.isEmpty && !description.isEmpty && !budget.isEmpty
    }
    
    private func saveTravel() {
        let newTravel = Travel(
            destination: destination,
            date: "\(formatDate(startDate)) - \(formatDate(endDate))",
            imageName: "tokyo",
            peopleCount: peopleCount,
            description: description,
            budget: Double(budget) ?? 0,
            currency: currency
        )
        viewModel.addTravel(newTravel)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: date)
    }
}
