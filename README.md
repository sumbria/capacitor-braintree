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
import { Plugins, registerWebPlugin } from '@capacitor/core';
import { BraintreePlugin } from 'capacitor-braintree';
...
registerWebPlugin(BraintreePlugin);
```

## API
```ts
Plugins.BraintreePlugin.setToken(token).then(() => {
    Plugins.BraintreePlugin.showDropIn({
        amount: '10.0',
        disabled: ['venmo'] // (optional) 'paypal', 'card', 'venmo', 'applePay'
    }).then((payment) => {
        if (payment.cancelled) {
            console.log('Payment cancelled!');
        } else {
            console.log(payment);
        }
    });
});
```
