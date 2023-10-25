//
//  FreeRunningHomeView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct FreeRunningHomeView: View {
    
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    @StateObject var locationManager = LocationManager()
    @StateObject var runningManager = RunningManager.shared
    @State var userLocation = ""
    
    var body: some View {
        ZStack {
            FreeRunningMap(userLocation: $userLocation)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Header(scrollOffset: 20)
                    .padding(.top, 8)
                Spacer()
                
                cardView
                   .overlay {
                       VStack(alignment: .leading) {
                           Text("자유 코스")
                               .font(.headline)
                               .padding(.bottom, 8)
                           
                           HStack {
                               Image(systemName: "mappin")
                               Text(userLocation)
                           }
                           .font(.subBody)
                           
                           Spacer()
                           SlideToUnlock(isUnlocked: $runningManager.start)
                               .onChange(of: runningManager.start) { _, _ in
                                   runningManager.startFreeRun()
                               }
                       }
                       .padding(EdgeInsets(top: 58, leading: 24, bottom: 24, trailing: 16))
                   }
                   .padding(EdgeInsets(top: 8, leading: 16, bottom: 80, trailing: 20))
            }
        }
        .preferredColorScheme(.dark)
    }
}

extension FreeRunningHomeView {
    private var cardView: some View {
        Rectangle()
            .fill(
                LinearGradient(colors: [.white20Color, .white20Color.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .roundedCorners(10, corners: [.topLeft])
            .roundedCorners(70, corners: [.topRight])
            .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
            .overlay(
                CustomRoundedRectangle(cornerRadiusTopLeft: 10, cornerRadiusTopRight: 79, cornerRadiusBottomLeft: 45, cornerRadiusBottomRight: 45)
            )
        
    }
}
