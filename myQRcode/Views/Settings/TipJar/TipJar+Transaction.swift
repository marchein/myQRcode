//
//  TipJar+Transaction.swift
//  myTodo
//
//  Created by Marc Hein on 20.11.18.
//  Copyright © 2018 Marc Hein Webdesign. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

extension TipJarTableViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
            productsArray = productsArray.reversed()
            productsArray.sort(by: { (p0, p1) -> Bool in
                return p0!.price.floatValue < p1!.price.floatValue
            })
        } else {
            print("There are no products.")
        }
        hasData = true
        DispatchQueue.main.async {
            self.navigationController?.hideAnimatedActivityIndicatorView()
            self.tableView.reloadData()
        }
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    func startTransaction() {
        if transactionInProgress || productsArray.count < 1 {
            return
        }
        
        let payment = SKPayment(product: self.productsArray[self.selectedProductIndex]!)
        SKPaymentQueue.default().add(payment)
        self.transactionInProgress = true
        self.navigationController?.displayAnimatedActivityIndicatorView()
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                self.navigationController?.hideAnimatedActivityIndicatorView()
                UserDefaults.standard.set(true, forKey: localStoreKeys.hasTipped)
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                impact.impactOccurred()
                showMessage(title: NSLocalizedString("tip_success", comment: ""), message: NSLocalizedString("tip_success_message", comment: ""), on: self)
            case SKPaymentTransactionState.failed:
                self.navigationController?.hideAnimatedActivityIndicatorView()
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                showMessage(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("transaction_error", comment: ""), on: self)
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
}

