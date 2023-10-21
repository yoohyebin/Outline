import SwiftUI

struct WorkoutDataView: View {
    @ObservedObject var runningViewModel: RunningViewModel
    @ObservedObject var digitalTimerViewModel: DigitalTimerViewModel
    let weight: Double = 60
    
    var body: some View {
        ZStack {
            Color("Gray900").ignoresSafeArea()
            VStack {
                DigitalTimerView(digitalTimerViewModel: digitalTimerViewModel)
                Spacer()
                WorkoutDataGrid(runningViewModel: runningViewModel, weight: weight)
            }
            .onChange(of: runningViewModel.distance) { _, _ in
                runningViewModel.kilocalorie = weight * (runningViewModel.totalDistance + runningViewModel.distance) / 1000 * 1.036
            }
            .frame(height: 300)
            .padding()
        }
    }
}

struct WorkoutDataGrid: View {
    let runningViewModel: RunningViewModel
    let weight: Double
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 36) {
            let averagePace = (runningViewModel.totalTime + runningViewModel.time) / (runningViewModel.totalDistance + runningViewModel.distance) * 1000
            
            WorkoutDataItem(value: String(format: "%.2f", (runningViewModel.totalDistance + runningViewModel.distance) / 1000), label: "킬로미터")
            WorkoutDataItem(value: averagePace.isNaN ? "-'--''" : String(format: "%02d'%02d''", Int(averagePace / 60), Int(averagePace) % 60), label: "평균 페이스")
            WorkoutDataItem(value: String(format: "%.0f", runningViewModel.kilocalorie), label: "칼로리")
            WorkoutDataItem(value: "--", label: "BPM")
        }
    }
}

struct WorkoutDataItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .foregroundColor(.white)
                .font(
                    Font.custom("Pretendard-SemiBold", size: 36)
                )
            Text(label)
                .font(Font.custom("Pretendard-Regular", size: 16))
                .foregroundColor(Color.gray500)
        }
    }
}

#Preview {
    WorkoutDataView(runningViewModel: RunningViewModel(), digitalTimerViewModel: DigitalTimerViewModel())
}
