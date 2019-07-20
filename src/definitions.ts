declare module "@capacitor/core" {
  interface PluginRegistry {
    BraintreePlugin: BraintreePlugin;
  }

}

interface UIResult {
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
  applePaycard: {
  };
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