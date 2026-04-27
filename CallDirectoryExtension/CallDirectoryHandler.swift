import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {
    
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        // On injecte les numéros dans l'ordre croissant (OBLIGATOIRE pour CallKit)
        addAllBlockingPhoneNumbers(to: context)
        
        // On dit au système que c'est terminé
        context.completeRequest()
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Le numéro de base : 33 9 48 00 00 00 (sans le +, iOS CallKit gère ça comme un Int64)
        let baseNumber: Int64 = 33948000000
        
        // On boucle 1 million de fois pour générer jusqu'à 33 9 48 99 99 99
        for i in 0...999999 {
            let phoneNumber = baseNumber + Int64(i)
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // Gérer l'erreur si besoin (utile pour le debug)
        print("Erreur CallKit : \(error.localizedDescription)")
    }
}
