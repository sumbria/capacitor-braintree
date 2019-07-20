import {Plugins} from "@capacitor/core";

declare global {
    interface PluginRegistry {
        BTPlugin?: BraintreePlugin;
    }
}

export interface UIResult {
    cancelled: boolean;
    nonce: string;
    type: string;
    localizedDescription: string;
    card: {
        lastTwo: string;
        network: string;
    };
    payPalAccount: {
        email: string;
        firstName: string;
        lastName: string;
        phone: string;
        billingAddress: string;
        shippingAddress: string;
        clientMetadataId: string;
        payerId: string;
    };
    applePaycard: {};
    threeDSecureCard: {
        liabilityShifted: boolean;
        liabilityShiftPossible: boolean;
    };
    venmoAccount: {
        username: string;
    };
}

export interface BraintreePlugin {
    setToken(options: { token: string }): Promise<any>;

    showDropIn(options: {
        amount: string;
        disabled?: string[];
    }): Promise<UIResult>
}

const {BTPlugin} = Plugins;

export class Braintree implements BraintreePlugin {
    setToken(options: { token: string }): Promise<any> {
        return BTPlugin.setToken(options);
    }

    showDropIn(options: {
        amount: string;
        disabled?: string[];
    }): Promise<UIResult> {
        return BTPlugin.showDropIn(options);
    }
}
