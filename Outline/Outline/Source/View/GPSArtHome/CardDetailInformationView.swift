//
//  CardDetailInformationView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct CardDetailInformationView: View {
    @Binding var showCopyLocationPopup: Bool
    var selectedCourse: GPSArtCourse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(selectedCourse.description)
                .multilineTextAlignment(.leading)
                .font(.customSubtitle2)
                .foregroundStyle(.customWhite)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
                .padding(0)
            
            Text("경로 정보")
                .font(.customSubtitle)
                .fontWeight(.semibold)
                .padding(.bottom, 6)
            VStack(alignment: .leading, spacing: 17) {
                HStack {
                    HStack {
                        Group {
                            Image(systemName: "flag")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("시작 위치")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text("\(selectedCourse.locationInfo.locality) \(selectedCourse.locationInfo.subLocality) \(selectedCourse.locationInfo.subThroughfare)")
                        .font(.customSubbody)
                    Text("복사")
                        .font(.customSubbody)
                        .foregroundStyle(.gray500)
                        .onTapGesture {
                            copyLocation()
                        }
                }
                HStack {
                    HStack {
                        Group {
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 16))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("난이도")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            if index < countForCourseLevel(selectedCourse.level) {
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(.customWhite)
                                    .frame(width: 8, height: 16)
                            } else {
                                RoundedRectangle(cornerRadius: 1)
                                    .foregroundColor(.clear)
                                    .frame(width: 8, height: 16)
                                    .background(.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 1)
                                            .inset(by: 0.1)
                                            .stroke(.white.opacity(0.3), lineWidth: 0.2)
                                    )
                            }
                        }
                    }
                }
                HStack {
                    HStack {
                        Group {
                            Image(systemName: "location")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("거리")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text("\(selectedCourse.courseLength, specifier: "%.0f")km")
                        .font(.customSubbody)
                }
                HStack {
                    HStack {
                        Group {
                            Image(systemName: "clock")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("예상 소요 시간")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text("\(selectedCourse.courseDuration.formatDurationInKoreanDetail())")
                        .font(.customSubbody)
                }
                HStack(alignment: .top) {
                    LazyHStack {
                        Group {
                            Image(systemName: "star.fill")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("핫플레이스")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text(concatenateHotSpotTitles(selectedCourse.hotSpots))
                        .font(.customSubbody)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 12)
            
            Divider()
            
            Text("경로 지도")
                .font(.customSubtitle)
                .fontWeight(.semibold)
            VStack(alignment: .leading, spacing: 8) {
                NavigationLink {
                    CardDetailMap(selectedCourse: selectedCourse)
                        .toolbarBackground(.hidden, for: .navigationBar)
                } label: {
                    CardDetailInformationMapView(
                        coursePaths: selectedCourse.coursePaths.toCLLocationCoordinates()
                    )
                    .frame(height: 200)
                }
                .buttonStyle(.plain)
                Text("경로 제작 \(selectedCourse.producer)님")
                    .font(.customSubbody)
                    .foregroundStyle(.gray600)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
    
    private func countForCourseLevel(_ level: CourseLevel) -> Int {
        switch level {
        case .easy:
            return 1
        case .normal:
            return 3
        case .hard:
            return 5
        }
    }
    
    private func copyLocation() {
        UIPasteboard.general.string = "\(selectedCourse.locationInfo.locality) \(selectedCourse.locationInfo.subLocality) \(selectedCourse.locationInfo.subThroughfare)"
        showCopyLocationPopup = true
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
            self.showCopyLocationPopup = false
        }
    }
    
    func concatenateHotSpotTitles(_ hotSpots: [HotSpot]) -> String {
        var result = ""
        
        for (index, hotSpot) in hotSpots.enumerated() {
            result += hotSpot.title
            if index != hotSpots.count - 1 {
                result += " ˑ " // Add a line break if it's not the last element
            }
        }
        return result
    }
}

#Preview {
    HomeTabView()
}
