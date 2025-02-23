//
//  CategoryScrollView.swift
//  Outline
//
//  Created by 김하은 on 10/16/23.
//

import SwiftUI
import Kingfisher

struct CategoryScrollView: View {
    @State private var loading = true
    @Binding var selectedCourse: CourseWithDistanceAndScore?
    @Binding var courseList: [CourseWithDistanceAndScore]
    @Binding var showDetailView: Bool
    @Binding var category: String
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if loading {
                RoundedRectangle(cornerRadius: 9.5)
                    .padding(.leading, 16)
                    .foregroundStyle(.clear)
                    .frame(width: 148, height: 16)
            } else {
                Text(category)
                    .padding(.leading, 16)
                    .font(.customSubtitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, -5)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(courseList, id: \.id) { currentCourse in
                        ZStack {
                            Button {
                                withAnimation(.bouncy(duration: 0.7)) {
                                    selectedCourse = currentCourse
                                    showDetailView = true
                                }
                            } label: {
                                ZStack {
                                    if showDetailView {
                                        Rectangle()
                                            .foregroundStyle(.clear)
                                    } else {
                                        KFImage(URL(string: currentCourse.course.thumbnailNeon))
                                            .resizable()
                                            .placeholder {
                                                Rectangle()
                                                    .foregroundColor(.gray700)
                                                    .onDisappear {
                                                        loading = false
                                                    }
                                                    .mask {
                                                        UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 30, style: .circular)
                                                    }
                                            }
                                            .matchedGeometryEffect(id: currentCourse.id, in: namespace)
                                            .transition(
                                                .asymmetric(insertion: .opacity.animation(.spring()), removal: .opacity.animation(.spring().delay(0.3)))
                                            )
                                    }
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: .black, location: 0.00),
                                            Gradient.Stop(color: .black.opacity(0), location: 1.00)
                                        ],
                                        startPoint: UnitPoint(x: 0.5, y: 0.9),
                                        endPoint: UnitPoint(x: 0.5, y: 0.1)
                                    )
                                    VStack(alignment: .leading, spacing: 4) {
                                       
                                        ScoreStar(score: currentCourse.score, size: .small)
                                            .padding(.top, 12)
                                        Spacer()
                                        Text("\(currentCourse.course.courseName)")
                                            .font(Font.system(size: 20).weight(.semibold))
                                            .foregroundColor(.white)
                                        HStack(spacing: 0) {
                                            Image(systemName: "mappin")
                                                .foregroundColor(.gray600)
                                            Text("\(currentCourse.course.locationInfo.locality) \(currentCourse.course.locationInfo.subLocality)")
                                                .foregroundColor(.gray600)
                                        }
                                        .font(.customCaption)
                                        .padding(.bottom, 21)
                                    }
                                    .padding(.leading, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .mask {
                                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 30)
                                }
                                .shadow(color: .white, radius: 0.5, y: -0.5)
                            }
                            .frame(
                                  width: UIScreen.main.bounds.width * 0.4,
                                  height: UIScreen.main.bounds.width * 0.4 * 1.45
                              )
                        }
                        .buttonStyle(CardButton())
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(UIScreen.main.bounds.width * 0.05)
        }
        .padding(.top, 40)
    }
}

#Preview {
    HomeTabView()
}
