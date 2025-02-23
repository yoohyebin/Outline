//
//  CardDetailMap.swift
//  Outline
//
//  Created by hyebin on 11/22/23.
//
import MapKit
import SwiftUI

struct CardDetailMap: View {
    @Environment(\.dismiss) private var dismiss
    @State private var places = [Place]()
    @State private var selectedAnnotation: SpotAnnotation?
    @State private var showCustomSheet = false
    @State private var showCopyLocationPopup = false {
        didSet {
            if showCopyLocationPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.showCopyLocationPopup = false
                }
            }
        }
    }
    
    var selectedCourse: GPSArtCourse
    
    var body: some View {
        ZStack {
            CardDetailMapView(
                places: $places,
                selectedAnnotation: $selectedAnnotation,
                coursePaths: selectedCourse.coursePaths.toCLLocationCoordinates()
            )
            .ignoresSafeArea()
            
            if showCustomSheet {
                if let place = selectedAnnotation {
                    pinDetails(selectedPin: place)
                }
            }
        }
        .overlay {
            if showCopyLocationPopup {
                RunningPopup(text: "시작 위치 도로명이 복사되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, -32)
            }
        }
        .onChange(of: selectedAnnotation) {
            withAnimation {
                showCustomSheet = selectedAnnotation != nil
            }
        }
        .onChange(of: showCustomSheet) {
            if showCustomSheet == false {
                withAnimation {
                    selectedAnnotation = nil
                }
            }
        }
        .onAppear {
            places.append(
                Place(
                    id: 0,
                    title: "시작 위치",
                    spotDescription: "\(selectedCourse.locationInfo.locality) \(selectedCourse.locationInfo.subLocality) \(selectedCourse.locationInfo.throughfare) \(selectedCourse.locationInfo.subThroughfare)",
                    location: CLLocationCoordinate2D(latitude: selectedCourse.startLocation.latitude, longitude: selectedCourse.startLocation.longitude)
                )
            )
            
            for (index, place) in selectedCourse.hotSpots.enumerated() {
                places.append(
                    Place(
                        id: index+1,
                        title: place.title,
                        spotDescription: place.spotDescription,
                        location: CLLocationCoordinate2D(latitude: place.location.latitude, longitude: place.location.longitude)
                    )
                )
            }
        }
    }
}

extension CardDetailMap {
    @ViewBuilder
    private func pinDetails(selectedPin: SpotAnnotation) -> some View {
        ZStack {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 8, opaque: true)
                .overlay(
                    UnevenRoundedRectangle(topLeadingRadius: 15, topTrailingRadius: 15)
                        .fill(.black50)
                )
                .ignoresSafeArea()
            
            ZStack {
                Capsule()
                    .frame(width: 36, height: 5)
                    .foregroundStyle(.gray600)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(selectedPin.title ?? "")
                                .font(.customTitle2)
                            if selectedPin.title == "시작위치" {
                                Button {
                                    copyLocation(selectedPin.title ?? "")
                                } label: {
                                    Image(systemName: "doc.on.doc.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.gray600)
                                }
                            }
                        }
                        Text(selectedPin.subtitle ?? "")
                            .font(.customSubbody)
                    }
                    
                    Spacer()
                    
                    Button {
                        showCustomSheet = false
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .font(.system(size: 24))
                    }
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 20)
        }
        .frame(height: 100)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .gesture(
            DragGesture()
                .onEnded { _ in
                    withAnimation {
                        showCustomSheet = false
                    }
                }
        )
    }
    
    private func copyLocation(_ copyString: String) {
        UIPasteboard.general.string = copyString
        showCopyLocationPopup = true
    }
}
