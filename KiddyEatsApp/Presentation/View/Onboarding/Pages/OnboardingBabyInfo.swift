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
                        HStack {
                            Text("Date of Birth")
                            Spacer()
                        }
                        ZStack {
                            Text(dateFormatter.string(from: vm.savedbabyDOB))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    showDatePicker = true
                                }
                                .sheet(isPresented: $showDatePicker, content: {
                                    VStack {
                                        Text("Select your baby date of birth")
                                        DatePicker("Select Date of Birth", selection: $vm.savedbabyDOB, in: dateRange, displayedComponents: .date)
                                            .datePickerStyle(.graphical)
                                            .labelsHidden()
                                            .presentationDetents([.height(500)])
                                        Button {
                                            showDatePicker = false
                                        } label: {
                                            Text("Done")
                                        }
                                        .buttonStyle(KiddyEatsProminentButtonStyle())
                                        .padding(.horizontal, 30)
                                    }
                                })
                            
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.white)
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
