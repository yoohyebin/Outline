//
//  RunningStartManager.swift
//  Outline
//
//  Created by hyunjun on 10/25/23.
//

import Combine
import CoreLocation
import HealthKit
import SwiftUI
import FirebaseAnalytics

class RunningStartManager: ObservableObject {
    @Published var counter = 0
    @Published var start = false
    @Published var running = false
    @Published var mirroring = false
    @Published var changeRunningType = false
    @Published var complete = false
    
    @Published var isHealthAuthorized = false
    @Published var isLocationAuthorized = false
    @Published var showPermissionSheet = false
    @Published var permissionType: PermissionType = .health
    
    private var timer: AnyCancellable?
    private var healthStore = HKHealthStore()
    private var locationManager = CLLocationManager()
    private let userDataModel = UserDataModel()
    private let quantityTypes: Set = [
        HKQuantityType(.heartRate),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.stepCount),
        HKQuantityType(.cyclingCadence),
        HKQuantityType(.runningSpeed),
        HKQuantityType.workoutType()
    ]
    var startCourse: GPSArtCourse?
    var runningType: RunningType = .gpsArt
    
    static let shared = RunningStartManager()
    
    private init() { }
    
    func checkAuthorization() -> Bool {
        checkHealthAuthorization()
        if !isHealthAuthorized {
            permissionType = .health
            showPermissionSheet = true
            return false
        }
        
        checkLocationAuthorization()
        if !isLocationAuthorized {
            permissionType = .location
            showPermissionSheet = true
            return false
        }
        
        return true
    }
    
    private func checkHealthAuthorization() {
        for quantityType in quantityTypes {
            let status = healthStore.authorizationStatus(for: quantityType)
            switch status {
            case .notDetermined:
                requestHealthAuthorization()
            case .sharingDenied:
                isHealthAuthorized = false
            case .sharingAuthorized:
                isHealthAuthorized = true
            @unknown default:
                isHealthAuthorized = false
            }
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            isLocationAuthorized = false
        case .restricted, .denied:
            isLocationAuthorized = false
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
        @unknown default:
            break
        }
    }
    
    private func requestHealthAuthorization() {
        healthStore.requestAuthorization(toShare: quantityTypes, read: quantityTypes) {_, _ in
            self.isHealthAuthorized = false
        }
    }
    
    func startFreeRun() {
        startCourse = GPSArtCourse()
        runningType = .free
        getFreeRunName()
        
        // 자유러닝 
        Analytics.logEvent("started_free_running", parameters: [
            "card_name": "자유러닝"
        ])
    }
    
    func startGPSArtRun() {
        runningType = .gpsArt
        
        // GPS 러닝
        guard let startCourse = startCourse else { return }
        Analytics.logEvent("started_gps_art_running", parameters: [
            "card_name": startCourse.courseName
        ])
    }
    
    private func getFreeRunName() {
        let geocoder = CLGeocoder()
        
        if let userLocation = locationManager.location?.coordinate {
            let start = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            geocoder.reverseGeocodeLocation(start) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let area = placemark.administrativeArea ?? ""
                    let city = placemark.locality ?? ""
                    let town = placemark.subLocality ?? ""
                    
                    self.startCourse?.courseName = "\(city) \(town)런"
                    self.startCourse?.regionDisplayName =  "\(area) \(city) \(town)"
                }
            }
        }
    }
    
    func trackingDistance() {
        if let startCourse {
            if !checkDistance(course: startCourse.coursePaths) {
                changeRunningType = true
            }
        }
    }
    
    func checkDistance(course: [Coordinate]) -> Bool {
        
        guard let userLocation = locationManager.location?.coordinate else { return false }
        
        guard let shortestDistance = calculateShortestDistance(from: userLocation, to: course.toCLLocationCoordinates()) else { return false }
        
        return shortestDistance <= 50
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.counter += 1
            }
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    func formattedTime(_ counter: Int) -> String {
        let minutes = counter / 60
        let seconds = counter % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func getFreeRunNumber(completion: @escaping (Result<Int, CoreDataError>) -> Void) {
        userDataModel.getFreeRunCount { result in
            switch result {
            case .success(let freeRunCount):
                completion(.success(freeRunCount))
            case .failure(let failure):
                print("fail to read free run count \(failure)")
                completion(.failure(.dataNotFound))
            }
        }
    }
}

// MARK: - 위치와 경로를 계산하는 함수

extension RunningStartManager {
    
    func calculateShortestDistance(from userCoordinate: CLLocationCoordinate2D, to courseCoordinates: [CLLocationCoordinate2D]) -> CLLocationDistance? {
        guard !courseCoordinates.isEmpty else { return nil }
        
        var shortestDistance: CLLocationDistance?
        
        for courseCoordinate in courseCoordinates {
            let distanceToCourseCoordinate = calculateDistance(from: userCoordinate, to: courseCoordinate)
            if let currentShortestDistance = shortestDistance {
                shortestDistance = min(currentShortestDistance, distanceToCourseCoordinate)
            } else {
                shortestDistance = distanceToCourseCoordinate
            }
        }
        return shortestDistance
    }
    
    // 두 좌표 사이의 거리를 계산하는 함수
    private func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
}
