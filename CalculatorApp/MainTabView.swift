//
//  MainTabView.swift
//  CalculatorApp
//
//  Created by 최민규 on 6/15/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TravelHomeView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("여행")
                }
            Text("달력")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("달력")
                }
            CalculatorView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("입력")
                }
            Text("통계")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("통계")
                }
            Text("설정")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("설정")
                }
        }
    }
}



#Preview {
    TravelHomeView()
}
