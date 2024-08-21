//
//  EditProfileView.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 21/08/24.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Bindable var vm: EditBabyProfileViewModel
    
    let dateRange: ClosedRange<Date> = {
        let today = Date()
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -2, to: today)!
        return oneYearAgo...today
    }()
    
    @State private var userInput = ""
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        KiddyEatsTextField(title: "Name", content: $vm.toUpdateBabyName)
                            .padding(.bottom, 10)
                            .padding(.top, 30)
                        KiddyEatsDatePicker(
                            title: "Date of birth",
                            placeholder: vm.fetchedBabyProfile?.dateOfBirth,
                            dateRange: dateRange,
                            date: $vm.toUpdateBabyDate
                        )
                        .padding(.bottom, 10)
                        
                        VStack(alignment: .leading) {
                            KiddyEatsTextField(title: "Enter Allergen", placeholder: "\"Peanuts\"", content: $userInput)
                                .onSubmit {
                                    addTag()
                                }
                                .padding(.bottom, 10)
                            Text("Enter your allergen and press Enter to add it. You can add more than one.")
                                .font(Font.system(size: 12))
                                .fontWeight(.light)
                        }
                        .padding(.bottom, 30)
                        
                        VStack {
                            KiddyEatsAllergenList(
                                title: "Possible Allergen Known",
                                tagList: $vm.toUpdateAllergenList,
                                removeTag: removeTags
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer()
                Button(action: {
                    vm.updateBabyProfile(modelContext: modelContext)
                    dismiss()
                }, label: {
                    Text("Save Changes")
                })
                .buttonStyle(KiddyEatsProminentButtonStyle())
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            vm.setupViewModel()
        }
    }
    
    func addTag(){
        if vm.toUpdateAllergenList.contains(userInput) == false {
            vm.toUpdateAllergenList.append(userInput)
            userInput.removeAll()
        }
        
    }
    
    func removeTags(name: String){
        vm.toUpdateAllergenList.removeAll(where: { tag in
            tag == name
        })
    }
}
