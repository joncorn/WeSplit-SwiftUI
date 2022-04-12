//
//  ContentView.swift
//  WeSplit
//
//  Created by Jon Corn on 4/11/22.
//

import SwiftUI

struct ContentView: View {
    // @State is a property that can change it's value in real time
    // based on users interaction with the view
    @State private var checkAmount    = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage  = 20
    // SwiftUI can tell if the user is focused on keyboard
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [0, 10, 15, 20, 25, 30]
    
    var currencyFormatter: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currencyCode ?? "USD")
    }
    
    var totalPerPerson: Double {
        // calculate the total per person here
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = tipValue + checkAmount
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalWithTip: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let totalPerPerson = totalPerPerson
        
        let total = peopleCount * totalPerPerson
        return total
    }
    
    var body: some View {
        // Adds the gray block of area underneath time and battery info
        NavigationView {
            // Similar to a tableview, it's a list view with sections
            Form {
                // List of items in section
                Section {
                    // text field, title with value of our @State check amount value
                    TextField("Amount", value: $checkAmount, format:
                        // in the form of our currency formatter
                        currencyFormatter)
                        // keyboard type when users taps text field
                        .keyboardType(.decimalPad)
                        // focused bool
                        .focused($amountIsFocused)
                    
                    // picker for how many people, using our @State value of number of people
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                // New section for tip percentage
                Section {
                    // New picker for tips, following same formula has number of people
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                // header adds gray caps header to top of section
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                // new section for amount per person using computed values
                Section {
                    Text(totalPerPerson, format: currencyFormatter)
                } header: {
                    Text("Amount per person")
                }
                
                // new section for total bill amount + tips
                Section {
                    Text(totalWithTip, format: currencyFormatter)
                } header: {
                    Text("Grand total")
                }
            }
            // Navigation titles go after Form, not navcontroller
            // Adds title that morphs into navbar back button on next screen
            .navigationTitle("WeSplit")
            // Adds toolbar item, for keyboard with done button, to keyboard
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
