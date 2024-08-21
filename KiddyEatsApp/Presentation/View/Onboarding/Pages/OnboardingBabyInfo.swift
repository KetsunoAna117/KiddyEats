//
//  OnboardingBabyInfo.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct OnboardingBabyInfo: View {
    @Bindable var vm: BabyOnboardingInformationViewModel
    @State private var showDatePicker = false
    
    let dateRange: ClosedRange<Date> = {
        let today = Date()
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -2, to: today)!
        return oneYearAgo...today
    }()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Your little one's basic details")
                        .font(Font.system(size: 18))
                        .fontWeight(.semibold)
                    Text("Let's start with their name and birthday")
                        .fontWeight(.light)
                }
                .padding(.top, 100)
                
                VStack {
                    VStack {
                        OnboardingTextField(title: "Name", placeholder: "Enter your baby's name here", content: $vm.savedbabyName)
                    }
                    
                    VStack {
                        OnboardingDatePicker(
                            title: "Date of birth",
                            placeholder: Date.now,
                            dateRange: dateRange,
                            date: $vm.savedbabyDOB
                        )
                    }
                    .padding(.top, 20)
                }
                .padding(.top, 30)
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            
        }
    }
}

#Preview {
    OnboardingView(onBoardingCompleted: {
        print("Onboarding Completed")
    })
}
