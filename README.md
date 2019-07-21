# capacitor-braintree
A Capacitor plugin for the Braintree mobile payment processing SDK

## Installation

```bash
$ npm i capacitor-braintree
```

## iOS configuration

Add the following in the `ios/App/App/info.plist` file:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>capacitor-braintree</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>{Bundle Identifier}.payments</string>
        </array>
    </dict>
</array>
```

More information can be found here: https://developers.braintreepayments.com/guides/paypal/client-side/ios/v4

## Android configuration
(Under development)

## Usage

```ts
import {Braintree, DropInResult} from 'capacitor-braintree';
...
const braintree = new Braintree();
braintree.setToken({
    token: token
}).then(
    () => {
        braintree.showDropIn({
            amount: '10.0'
        }).then(
            (payment: DropInResult) => {
                console.log(payment);
            }).catch((error) => {
            console.log(error);
        });

    }).catch((error) => {
    console.log(error);
});
```
