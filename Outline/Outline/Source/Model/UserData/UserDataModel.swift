//
//  UserDataModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/17/23.
//

import CoreData
import CoreLocation
import SwiftUI

protocol UserDataModelProtocol {
    func createRunningRecord(
        record: RunningRecord,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    )
    func updateRunningRecordCourseName(
        _ record: NSManagedObject,
        newCourseName: String,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    )
    func deleteRunningRecord(
        _ object: NSManagedObject,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    )
    func deleteAllRunningRecord(
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    )
}

enum CoreDataError: Error {
    case saveFailed
    case dataNotFound
    case deleteFail
}

struct UserDataModel: UserDataModelProtocol {
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: []) var runningRecord: FetchedResults<CoreRunningRecord>
    
    let persistenceController = PersistenceController.shared
    
    private func saveContext() throws {
        do {
            try persistenceController.container.viewContext.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    func getFreeRunCount(completion: @escaping (Result<Int, CoreDataError>) -> Void) {
        let request = CoreRunningRecord.fetchRequest()
        do {
            let runningRecords = try persistenceController.container.viewContext.fetch(request)
            var freeRunCount: Int = 0
            for record in runningRecords {
                if let runningType = record.runningType, runningType == "free" {
                    freeRunCount += 1
                }
            }
            completion(.success(freeRunCount))
        } catch {
            print("fetch Person error: \(error)")
            completion(.failure(.dataNotFound))
        }
    }
    
    func createRunningRecord(
        record: RunningRecord,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    ) {
        let newRunningRecord = CoreRunningRecord(context: persistenceController.container.viewContext)
        newRunningRecord.runningType = record.runningType.rawValue
        newRunningRecord.id = UUID().uuidString
        
        let context = persistenceController.container.viewContext
        let newCourseData = CoreCourseData(context: context)
        newCourseData.setValue(record.courseData.courseName, forKey: "courseName")
        newCourseData.setValue(record.courseData.runningLength, forKey: "runningLength")
        newCourseData.setValue(record.courseData.heading, forKey: "heading")
        newCourseData.setValue(record.courseData.distance, forKey: "distance")
        newCourseData.setValue(record.courseData.heading, forKey: "heading")
        newCourseData.setValue(record.courseData.regionDisplayName, forKey: "regionDisplayName")
        newCourseData.setValue(record.courseData.score, forKey: "score")
        
        var pathList: [CoreCoordinate] = []
        for path in record.courseData.coursePaths {
            let newPath = CoreCoordinate(entity: CoreCoordinate.entity(), insertInto: persistenceController.container.viewContext)
            newPath.latitude = path.latitude
            newPath.longitude = path.longitude
            pathList.append(newPath)
        }
        
        newCourseData.coursePaths = NSOrderedSet(array: pathList)
        newCourseData.parentRecord = newRunningRecord
        
        let newHealthData = CoreHealthData(context: persistenceController.container.viewContext)
        newHealthData.setValue(record.healthData.totalTime, forKey: "totalTime")
        newHealthData.setValue(record.healthData.averageCadence, forKey: "averageCadence")
        newHealthData.setValue(record.healthData.totalRunningDistance, forKey: "totalRunningDistance")
        newHealthData.setValue(record.healthData.totalEnergy, forKey: "totalEnergy")
        newHealthData.setValue(record.healthData.averageHeartRate, forKey: "averageHeartRate")
        newHealthData.setValue(record.healthData.averagePace, forKey: "averagePace")
        newHealthData.setValue(record.healthData.startDate, forKey: "startDate")
        newHealthData.setValue(record.healthData.endDate, forKey: "endDate")
        
        newHealthData.recordHeathData = newRunningRecord
        
        do {
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(.saveFailed))
        }
    }
    
    func updateRunningRecordCourseName(
        _ record: NSManagedObject,
        newCourseName: String,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    ) {
        guard let record = record as? CoreRunningRecord else {
            completion(.failure(.dataNotFound))
            return
        }
        
        record.courseData?.setValue(newCourseName, forKey: "courseName")
        
        do {
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(.saveFailed))
        }
    }
    
    func deleteRunningRecord(
        _ object: NSManagedObject,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    ) {
        persistenceController.container.viewContext.delete(object)
        
        do {
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(.saveFailed))
        }
    }
    
    func deleteAllRunningRecord(completion: @escaping (Result<Bool, CoreDataError>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreRunningRecord")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistenceController.container.viewContext.execute(batchDeleteRequest)
            completion(.success(true))
        } catch {
            completion(.failure(.deleteFail))
        }
    }
}

/// CoreRunningRecord를 RunningRecord로 변환
extension UserDataModel {
    func convertToRunningRecord(coreRecord: CoreRunningRecord) -> RunningRecord? {
        guard
            let runningType = coreRecord.runningType,
            let courseData = coreRecord.courseData,
            let healthData = coreRecord.healthData,
            let startDate = healthData.startDate,
            let endDate = healthData.endDate,
            let courseName = courseData.courseName else {
                return nil
        }

        let runningTypeEnum = RunningType(rawValue: runningType) ?? .free
        
        var coursePaths: [CLLocationCoordinate2D] = []
        if let paths = courseData.coursePaths?.array as? [CoreCoordinate] {
            coursePaths = paths.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        }

        let courseDataStruct = CourseData(
            courseName: courseName,
            runningLength: courseData.runningLength,
            heading: courseData.heading,
            distance: courseData.distance,
            coursePaths: coursePaths,
            runningCourseId: courseData.parentRecord?.id ?? "",
            regionDisplayName: courseData.regionDisplayName ?? "",
            score: Int(courseData.score)
        )
        
        let healthDataStruct = HealthData(
            totalTime: healthData.totalTime,
            averageCadence: healthData.averageCadence,
            totalRunningDistance: healthData.totalRunningDistance,
            totalEnergy: healthData.totalEnergy,
            averageHeartRate: healthData.averageHeartRate,
            averagePace: healthData.averagePace,
            startDate: startDate,
            endDate: endDate
        )
        
        return RunningRecord(
            id: coreRecord.id ?? UUID().uuidString,
            runningType: runningTypeEnum,
            courseData: courseDataStruct,
            healthData: healthDataStruct
        )
    }
}
