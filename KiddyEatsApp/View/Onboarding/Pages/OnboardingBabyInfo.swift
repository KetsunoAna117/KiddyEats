//
//  OnboardingBabyInfo.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import SwiftUI

struct OnboardingBabyInfo: View {
    @Bindable var vm: BabyInformationViewModel
    @State private var showDatePicker = false
    
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
                        OnboardingTextField(title: "Name", placeholder: "Enter your baby's name here", content: $vm.babyName)
                    }
                    
                    VStack {
                        HStack {
                            Text("Date of Birth")
                            Spacer()
                        }
                        ZStack {
                            Text(dateFormatter.string(from: vm.babyDOB))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    showDatePicker = true
                                }
                                .sheet(isPresented: $showDatePicker, content: {
                                    DatePicker("Select Date of Birth", selection: $vm.babyDOB, displayedComponents: .date)
                                        .datePickerStyle(.wheel)
                                        .labelsHidden()
                                        .presentationDetents([.medium])
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
   OnboardingView()
}
