//
//  GPSArtHomeViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/19/23.
//

import CoreLocation
import CoreData
import SwiftUI
import CoreMotion

struct CourseWithDistance: Identifiable, Hashable {
    var id = UUID().uuidString
    var course: GPSArtCourse
    var distance: Double
}

class GPSArtHomeViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var courses: AllGPSArtCourses = []
    @Published var recommendedCoures: [CourseWithDistance] = []
    @Published var withoutRecommendedCourses: [CourseWithDistance] = []
    @Published private var watchCourses: [GPSArtCourse] = []
    
    private let courseModel = CourseModel()
    private let locationManager = CLLocationManager()
    private let watchConnectivityManager = WatchConnectivityManager.shared
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getAllCoursesFromFirebase() {
        courseModel.readAllCourses { result in
            switch result {
            case .success(let courseList):
                self.courses = courseList
                self.fetchRecommendedCourses()
                self.watchConnectivityManager.sendGPSArtCoursesToWatch(self.watchCourses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchRecommendedCourses() {
        let userlocation = locationManager.location?.coordinate
        
        if let location = userlocation {
            let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            // 코스와 해당 거리를 함께 저장하는 배열
            var courseDistances: [CourseWithDistance] = []
            
            // 각 코스의 거리를 계산하여 배열에 추가
            for course in self.courses {
                guard let firstCoordinate = course.coursePaths.first else { continue }
                let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
                let distance = currentCLLocation.distance(from: courseLocation)
                courseDistances.append(CourseWithDistance(course: course, distance: distance))
            }
            
            // 거리에 따라 배열을 정렬
            courseDistances.sort { $0.distance < $1.distance }
            
            // 워치에 보내는 코스
            for courseDistance in courseDistances {
                watchCourses.append(courseDistance.course)
            }
            
            // 가장 가까운 세 개의 코스와 그 외의 코스로 분리
            self.recommendedCoures = Array(courseDistances.prefix(3))
            self.withoutRecommendedCourses = Array(courseDistances.dropFirst(3))
        } else {
            // 위치 정보가 없을 경우 앞의 세 코스를 추천 코스로 표시하고 나머지는 추천되지 않은 코스로 표시
            self.recommendedCoures = self.courses.prefix(3).map { CourseWithDistance(course: $0, distance: 0) }
            self.withoutRecommendedCourses = Array(self.courses.dropFirst(3)).map { CourseWithDistance(course: $0, distance: 0) }
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            requestMotionAccess()
        case .authorizedAlways, .authorizedWhenInUse:
            requestMotionAccess()
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    private func requestMotionAccess() {
        let motionManager = CMMotionActivityManager()
        
        if CMMotionActivityManager.isActivityAvailable() {
            motionManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, _ in }
        }
    }
}
