import Foundation
import Capacitor
import Braintree
import BraintreeDropIn

@objc(BraintreePlugin)
public class BraintreePlugin: CAPPlugin {
    var token: String!
    
    /**
     * Set Braintree API token
     * Set Braintree Switch URL
     */
    @objc func setToken(_ call: CAPPluginCall) {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        BTAppSwitch.setReturnURLScheme("\(bundleIdentifier).payments")
        
        self.token = call.getString("token") ?? ""
        if self.token.isEmpty {
            call.reject("A token is required.")
            return
        }
        call.success()
    }
    
    /**
     * Show DropIn UI
     */
    @objc func showDropIn(_ call: CAPPluginCall) {
        guard let amount = call.getString("amount") else {
            call.reject("An amount is required.")
            return;
        }
        
        /**
         * DropIn UI Request
         */
        let request = BTDropInRequest()
        request.amount = amount
        
        /**
         * Disabble Payment Methods
         */
        let disabled = call.getArray("disabled", String.self)
        if disabled!.contains("paypal") {
            request.paypalDisabled = true;
        }
        if disabled!.contains("venmo") {
            request.venmoDisabled = true;
        }
        if disabled!.contains("apple-pay") {
            request.applePayDisabled = true;
        }
        if disabled!.contains("card") {
            request.cardDisabled = true;
        }
        
        /**
         * Initialize DropIn UI
         */
        let dropIn = BTDropInController(authorization: self.token, request: request)
        { (controller, result, error) in
            if (error != nil) {
                call.reject("Something went wrong.")
            } else if (result?.isCancelled == true) {
                call.success(["cancelled": true])
            } else if let result = result {
                call.success(self.getPaymentMethodNonce(paymentMethodNonce: result.paymentMethod!))
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.bridge.viewController.present(dropIn!, animated: true, completion: nil)
        
    }
    
    @objc func getPaymentMethodNonce(paymentMethodNonce: BTPaymentMethodNonce) -> [String:Any] {
        var payPalAccountNonce: BTPayPalAccountNonce
        var cardNonce: BTCardNonce
        var venmoAccountNonce: BTVenmoAccountNonce
        
        var response: [String: Any] = ["cancelled": false]
        response["nonce"] = paymentMethodNonce.nonce
        response["type"] = paymentMethodNonce.type
        response["localizedDescription"] = paymentMethodNonce.localizedDescription
        
        /**
         * Handle Paypal Response
         */
        if(paymentMethodNonce is BTPayPalAccountNonce){
            payPalAccountNonce = paymentMethodNonce as! BTPayPalAccountNonce
            response["paypal"] = [
                "email": payPalAccountNonce.email,
                "firstName": payPalAccountNonce.firstName,
                "lastName": payPalAccountNonce.lastName,
                "phone": payPalAccountNonce.phone,
                "clientMetadataId": payPalAccountNonce.clientMetadataId,
                "payerId": payPalAccountNonce.payerId
            ]
        }
        
        /**
         * Handle Card Response
         */
        if(paymentMethodNonce is BTCardNonce){
            cardNonce = paymentMethodNonce as! BTCardNonce
            response["card"] = [
                "lastTwo": cardNonce.lastTwo!,
                "network": cardNonce.cardNetwork
            ]
        }
        
        /**
         * Handle Card Response
         */
        if(paymentMethodNonce is BTVenmoAccountNonce){
            venmoAccountNonce = paymentMethodNonce as! BTVenmoAccountNonce
            response["venmo"] = [
                "username": venmoAccountNonce.username
            ]
        }
        
        return response;
        
    }
}
