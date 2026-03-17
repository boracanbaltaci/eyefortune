import Foundation
import StoreKit
import Combine

@MainActor
class StoreManager: ObservableObject {
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var purchasedSubscriptions: [String] = []
    
    private let productIds = [
        "com.boradev.eyesee.monthly",
        "com.boradev.eyesee.annual"
    ]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        updateListenerTask = listenForTransactions()
        
        Task {
            await fetchProducts()
            await updatePurchasedSubscriptions()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func fetchProducts() async {
        do {
            let products = try await Product.products(for: productIds)
            self.subscriptions = products.sorted(by: { $0.price < $1.price })
            print("Successfully fetched products: \(products.count)")
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePurchasedSubscriptions()
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func updatePurchasedSubscriptions() async {
        var purchased: [String] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.productType == .autoRenewable {
                    purchased.append(transaction.productID)
                }
            } catch {
                print("Transaction verification failed")
            }
        }
        
        self.purchasedSubscriptions = purchased
        
        // Sync with AppStorage if needed
        UserDefaults.standard.set(!purchased.isEmpty, forKey: "isPremium")
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updatePurchasedSubscriptions()
                    await transaction.finish()
                } catch {
                    print("Transaction update failed")
                }
            }
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
