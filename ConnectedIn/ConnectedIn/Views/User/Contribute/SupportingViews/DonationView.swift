//
//  DonationView.swift
//  ConnectedIn
//
//  Created by Richard John Alamer on 11/20/24.
//

import SwiftUI

struct DonationView: View {
    @StateObject private var viewModel: DonationViewModel
    @Environment(\.dismiss) var dismiss
    
    init(recipient: any Recipient) {
        _viewModel = StateObject(wrappedValue: DonationViewModel(recipient: recipient))
    }
    
    var body: some View {
        Form {
            // Recipient Information Section
            Section("Recipient Information") {
                recipientInfoView
            }
            
            // Amount Section
            Section("Donation Amount") {
                amountSelectionView
            }
            
            // Payment Method Section
            Section("Payment Method") {
                paymentMethodView
            }
            
            // Donation Button
            Section {
                Button(action: {
                    Task {
                        await viewModel.processDonation()
                    }
                }) {
                    Text("Donate ₱\(String(format: "%.2f", viewModel.selectedAmount))")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
                .disabled(!viewModel.isValidDonation)
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Make a Donation")
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Thank you for your donation!")
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
    }
    
    private var recipientInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.recipientName)
                .font(.headline)
            Text(viewModel.recipientType)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var amountSelectionView: some View {
        VStack(spacing: 16) {
            // Predefined amounts
            HStack(spacing: 12) {
                ForEach([100, 500, 1000, 5000], id: \.self) { amount in
                    Button("\(amount)") {
                        viewModel.selectedAmount = Double(amount)
                    }
                    .buttonStyle(.bordered)
                    .tint(viewModel.selectedAmount == Double(amount) ? .blue : .secondary)
                }
            }
            
            // Custom amount input
            TextField("Other Amount", value: $viewModel.selectedAmount, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private var paymentMethodView: some View {
        Picker("Payment Method", selection: $viewModel.selectedPaymentMethod) {
            ForEach(PaymentMethod.allCases, id: \.self) { method in
                Text(method.rawValue).tag(method)
            }
        }
        .pickerStyle(.navigationLink)
    }
}

//#Preview {
//    DonationView()
//}
