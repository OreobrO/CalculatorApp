//
//  SpentListView.swift
//  CalculatorApp
//
//  Created by 최민규 on 6/7/25.
//

import SwiftUI

enum ExpenseCategory: String, CaseIterable {
    case accommodation = "숙소"
    case food = "식비"
    case shopping = "쇼핑"
    case transportation = "교통"
    case insurance = "보험"
    case activity = "활동"
}

enum PaymentMethod: String, CaseIterable {
    case card = "카드"
    case cash = "현금"
}

struct ExpenseItem: Identifiable {
    let id = UUID()
    let date: String
    var category: String
    var method: String
    var description: String
    let amountKRW: String
    let amountYEN: String
    let minGyu: String
    let hyunWoo: String
    let beomSoo: String
    let sangMin: String
    let exchangeRate: String
}

struct SpentListView: View {
    @State private var selectedDate: Date = Date()
    @State private var showingDatePicker = false
    @State private var selectedItemIndex: Int? = nil
    @State private var zoomLevel: Int = 2 // 0: 50%, 1: 75%, 2: 100%, 3: 125%, 4: 150%
    @State private var showingCalculator = false
    @State private var selectedAmountField: (row: Int, field: String)? = nil
    @State private var calculatorResult: String = ""
    @State private var showingCategoryPicker = false
    @State private var showingMethodPicker = false
    @State private var selectedCategory: ExpenseCategory = .accommodation
    @State private var selectedMethod: PaymentMethod = .card
    @State private var editingDescription: String = ""
    @State private var editingRow: Int? = nil
    @State private var isEditingDescription = false
    
    let columns = [
        "날짜", "종류", "결제수단", "내용", "금액(원)", "금액(엔)",
        "민규", "현우", "범수", "상민", "적용환율"
    ]
    
    let data: [ExpenseItem] = [
        ExpenseItem(
            date: "2025.01.24", category: "숙소", method: "카드", description: "크로스호텔삿포로",
            amountKRW: "38698", amountYEN: "₩181,803", minGyu: "₩181,803", hyunWoo: "₩181,803",
            beomSoo: "", sangMin: "", exchangeRate: "939.6"
        ),
        ExpenseItem(
            date: "2025.02.06", category: "쇼핑", method: "카드", description: "빅로건규",
            amountKRW: "21000", amountYEN: "₩197,316", minGyu: "₩197,316", hyunWoo: "", beomSoo: "", sangMin: "", exchangeRate: "950.65"
        )
    ]
    
    let baseCellWidth: CGFloat = 90  // 120에서 90으로 축소
    let baseCellHeight: CGFloat = 32  // 40에서 32로 축소
    let totalRows = 10
    let baseFontSize: CGFloat = 13    // 14에서 13으로 축소
    
    var scale: CGFloat {
        switch zoomLevel {
        case 0: return 0.5  // 50%
        case 1: return 0.75 // 75%
        case 2: return 1.0  // 100%
        case 3: return 1.25 // 125%
        case 4: return 1.5  // 150%
        default: return 1.0
        }
    }
    
    var cellWidth: CGFloat {
        baseCellWidth * scale
    }
    
    var cellHeight: CGFloat {
        baseCellHeight * scale
    }
    
    var fontSize: CGFloat {
        baseFontSize * scale
    }
    
    func getCategoryColor(_ category: String) -> Color {
        switch category {
        case "숙소":
            return Color.blue.opacity(0.1)
        case "식비":
            return Color.green.opacity(0.1)
        case "쇼핑":
            return Color.purple.opacity(0.1)
        case "교통":
            return Color.orange.opacity(0.1)
        case "보험":
            return Color.red.opacity(0.1)
        case "활동":
            return Color.yellow.opacity(0.1)
        default:
            return Color.clear
        }
    }
    
    var body: some View {
        VStack {
            // 확대/축소 버튼
            HStack {
                Spacer()
                HStack(spacing: 10) {
                    Button(action: {
                        zoomLevel = max(zoomLevel - 1, 0)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                    }
                    
                    Text("\(["S", "M", "L", "XL", "XXL"][zoomLevel])")
                        .frame(width: 40)
                    
                    Button(action: {
                        zoomLevel = min(zoomLevel + 1, 4)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                .padding()
            }
            
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment: .leading, spacing: 0) {
                    // 헤더
                    HStack(spacing: 0) {
                        ForEach(columns.indices, id: \.self) { index in
                            Text(columns[index])
                                .font(.system(size: fontSize, weight: .bold))
                                .frame(width: cellWidth, height: cellHeight)
                                .padding(.horizontal, 4)  // 좌우 패딩 축소
                                .padding(.vertical, 2)   // 상하 패딩 축소
                                .background(index == 0 ? Color.yellow.opacity(0.4) : Color.gray.opacity(0.2))
                                .border(Color.gray.opacity(0.3))
                        }
                    }
                    Divider()
                    
                    // 데이터 행
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        HStack(spacing: 0) {
                            Button(action: {
                                selectedItemIndex = index
                                showingDatePicker = true
                            }) {
                                Text(item.date)
                                    .font(.system(size: fontSize))
                                    .frame(width: cellWidth, height: cellHeight)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.yellow.opacity(0.1))
                                    .border(Color.gray.opacity(0.1))
                            }
                            
                            Menu {
                                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                                    Button(category.rawValue) {
                                        // TODO: 카테고리 업데이트 로직
                                    }
                                }
                            } label: {
                                Text(item.category)
                                    .font(.system(size: fontSize))
                                    .frame(width: cellWidth, height: cellHeight)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .border(Color.gray.opacity(0.1))
                            }
                            
                            Menu {
                                ForEach(PaymentMethod.allCases, id: \.self) { method in
                                    Button(method.rawValue) {
                                        // TODO: 결제수단 업데이트 로직
                                    }
                                }
                            } label: {
                                Text(item.method)
                                    .font(.system(size: fontSize))
                                    .frame(width: cellWidth, height: cellHeight)
                                    .padding(.horizontal, 4)  // 좌우 패딩 축소
                                    .padding(.vertical, 2)   // 상하 패딩 축소
                                    .border(Color.gray.opacity(0.1))
                            }
                            
                            if isEditingDescription && editingRow == index {
                                TextField("내용을 입력하세요", text: $editingDescription, onCommit: {
                                    // TODO: 내용 업데이트 로직
                                    isEditingDescription = false
                                    editingRow = nil
                                })
                                .font(.system(size: fontSize))
                                .frame(width: cellWidth, height: cellHeight)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .border(Color.blue.opacity(0.5))
                                .background(Color.white)
                            } else {
                                Button(action: {
                                    editingRow = index
                                    editingDescription = item.description
                                    isEditingDescription = true
                                }) {
                                    Text(item.description)
                                        .font(.system(size: fontSize))
                                        .frame(width: cellWidth, height: cellHeight)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 2)
                                        .border(Color.gray.opacity(0.1))
                                }
                            }
                            
                            Button(action: {
                                selectedAmountField = (index, "amountKRW")
                                showingCalculator = true
                            }) {
                                Text(item.amountKRW)
                                    .font(.system(size: fontSize))
                                    .frame(width: cellWidth, height: cellHeight)
                                    .padding(.horizontal, 4)  // 좌우 패딩 축소
                                    .padding(.vertical, 2)   // 상하 패딩 축소
                                    .border(Color.gray.opacity(0.1))
                            }
                            
                            Button(action: {
                                selectedAmountField = (index, "amountYEN")
                                showingCalculator = true
                            }) {
                                Text(item.amountYEN)
                                    .font(.system(size: fontSize))
                                    .frame(width: cellWidth, height: cellHeight)
                                    .padding(.horizontal, 4)  // 좌우 패딩 축소
                                    .padding(.vertical, 2)   // 상하 패딩 축소
                                    .border(Color.gray.opacity(0.1))
                            }
                            
                            Text(item.minGyu)
                                .font(.system(size: fontSize))
                                .frame(width: cellWidth, height: cellHeight)
                                .padding(.horizontal, 4)  // 좌우 패딩 축소
                                .padding(.vertical, 2)   // 상하 패딩 축소
                                .border(Color.gray.opacity(0.1))
                            
                            Text(item.hyunWoo)
                                .font(.system(size: fontSize))
                                .frame(width: cellWidth, height: cellHeight)
                                .padding(.horizontal, 4)  // 좌우 패딩 축소
                                .padding(.vertical, 2)   // 상하 패딩 축소
                                .border(Color.gray.opacity(0.1))
                            
                            Text(item.beomSoo)
                                .font(.system(size: fontSize))
                                .frame(width: cellWidth, height: cellHeight)
                                .padding(.horizontal, 4)  // 좌우 패딩 축소
                                .padding(.vertical, 2)   // 상하 패딩 축소
                                .border(Color.gray.opacity(0.1))
                            
                            Text(item.sangMin)
                                .font(.system(size: fontSize))
                                .frame(width: cellWidth, height: cellHeight)
                                .padding(.horizontal, 4)  // 좌우 패딩 축소
                                .padding(.vertical, 2)   // 상하 패딩 축소
                                .border(Color.gray.opacity(0.1))
                            
                            Text(item.exchangeRate)
                                .font(.system(size: fontSize))
                                .frame(width: cellWidth, height: cellHeight)
                                .padding(.horizontal, 4)  // 좌우 패딩 축소
                                .padding(.vertical, 2)   // 상하 패딩 축소
                                .border(Color.gray.opacity(0.1))
                        }
                        .background(getCategoryColor(item.category))
                        Divider()
                    }
                    
                    // 빈 행 추가
                    ForEach(data.count..<totalRows, id: \.self) { _ in
                        HStack(spacing: 0) {
                            ForEach(0..<columns.count, id: \.self) { index in
                                Text("")
                                    .font(.system(size: fontSize))
                                    .frame(width: cellWidth, height: cellHeight)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(index == 0 ? Color.yellow.opacity(0.1) : Color.clear)
                                    .border(Color.gray.opacity(0.1))
                            }
                        }
                        Divider()
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate, isPresented: $showingDatePicker)
        }
        .sheet(isPresented: $showingCalculator) {
            CalculatorView()
                .presentationDetents([.height(450)])  // 모달 높이를 450으로 고정
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "날짜 선택",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                Button("완료") {
                    isPresented = false
                }
                .padding()
            }
            .navigationTitle("날짜 선택")
        }
    }
}

#Preview {
    SpentListView()
}
