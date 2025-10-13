# 💳 PayPal Subscription Setup Guide

## Real Payment Integration - Connect Your PayPal Account

Your website now has **REAL PayPal subscription integration**! Follow these steps to start accepting payments.

---

## Step 1: Create PayPal Business Account (5 minutes)

### 1.1 Sign Up
1. Go to https://www.paypal.com/businessmanage/account/create
2. Click **"Get Started"** under Business Account
3. Enter your business information:
   - Business name: `BetSage` (or your business name)
   - Business type: `Individual/Sole Proprietor` or `Company`
   - Email address
   - Password
4. Complete verification

### 1.2 Verify Your Account
1. Verify your email address
2. Add bank account (required for withdrawals)
3. Complete identity verification if prompted

---

## Step 2: Create Subscription Plans (10 minutes)

### 2.1 Access PayPal Developer Dashboard
1. Go to https://developer.paypal.com/
2. Log in with your PayPal account
3. Click **"Dashboard"** in top right

### 2.2 Create App
1. Click **"Apps & Credentials"**
2. Switch to **"Live"** mode (top right toggle)
3. Click **"Create App"**
4. App name: `BetSage Subscriptions`
5. Click **"Create App"**
6. **COPY YOUR CLIENT ID** - You'll need this!

### 2.3 Create Subscription Plans

#### Monthly Plan ($9.99/month)
1. Go to https://www.paypal.com/billing/plans
2. Click **"Create Plan"**
3. Fill in details:
   - **Plan name:** BetSage Premium Monthly
   - **Plan ID:** Leave blank (auto-generated)
   - **Description:** Premium access to all BetSage features
   - **Billing cycle:** Monthly
   - **Price:** $9.99 USD
   - **Setup fee:** $0
   - **Trial period:** Optional (e.g., 7 days free)
4. Click **"Create Plan"**
5. **COPY THE PLAN ID** - You'll need this!

#### Yearly Plan ($49.99/year)
1. Click **"Create Plan"** again
2. Fill in details:
   - **Plan name:** BetSage Premium Yearly
   - **Plan ID:** Leave blank (auto-generated)
   - **Description:** Premium access to all BetSage features (Best Value!)
   - **Billing cycle:** Yearly
   - **Price:** $49.99 USD
   - **Setup fee:** $0
   - **Trial period:** Optional
3. Click **"Create Plan"**
4. **COPY THE PLAN ID** - You'll need this!

---

## Step 3: Update Your Code (2 minutes)

### 3.1 Open `auth/paypal-config.js`

Replace these values:

```javascript
class PayPalSubscription {
    constructor() {
        this.clientId = 'YOUR_PAYPAL_CLIENT_ID'; // ← Replace this
        this.planIds = {
            monthly: 'YOUR_MONTHLY_PLAN_ID',  // ← Replace this
            yearly: 'YOUR_YEARLY_PLAN_ID'     // ← Replace this
        };
    }
}
```

### 3.2 Example (with your actual IDs):

```javascript
class PayPalSubscription {
    constructor() {
        this.clientId = 'AeB1234567890XYZ...'; // Your Client ID from Step 2.2
        this.planIds = {
            monthly: 'P-12345ABCDE',  // Your Monthly Plan ID from Step 2.3
            yearly: 'P-67890FGHIJ'    // Your Yearly Plan ID from Step 2.3
        };
    }
}
```

---

## Step 4: Test Your Integration (5 minutes)

### 4.1 Use PayPal Sandbox (Test Mode)

For testing without real money:

1. Go to https://developer.paypal.com/dashboard/
2. Switch to **"Sandbox"** mode
3. Create sandbox accounts:
   - Business account (seller)
   - Personal account (buyer)
4. Create sandbox plans (same as Step 2.3)
5. Use sandbox Client ID in your code
6. Test with sandbox buyer account

### 4.2 Test Live Payments

1. Visit your website: `https://your-site.vercel.app/games/premium.html`
2. Click **"Subscribe Monthly"** or **"Subscribe Yearly"**
3. PayPal popup will appear
4. Complete payment with your PayPal account
5. ✅ Subscription activated!

---

## Step 5: Go Live! (1 minute)

### 5.1 Switch to Production
1. In `auth/paypal-config.js`, use **LIVE** credentials:
   - Live Client ID (from Step 2.2)
   - Live Plan IDs (from Step 2.3)

### 5.2 Deploy
```bash
git add .
git commit -m "Add PayPal subscription integration"
git push origin main
```

### 5.3 Verify
1. Wait for Vercel deployment (~30 seconds)
2. Visit your live site
3. Test a real subscription
4. ✅ You're now accepting payments!

---

## Features Included

### ✅ Automatic Subscription Management
- Monthly/Yearly billing cycles
- Automatic renewals
- Subscription cancellation
- Payment retry on failure

### ✅ User Experience
- One-click PayPal checkout
- Instant premium activation
- Secure payment processing
- Mobile-optimized

### ✅ Security
- PCI DSS compliant (PayPal handles it)
- No credit card data stored
- Encrypted transactions
- Fraud protection

---

## Pricing & Fees

### PayPal Fees (Standard)
- **2.9% + $0.30** per transaction
- No monthly fees
- No setup fees

### Your Revenue (Example)
- Monthly ($9.99): You receive **$9.40** per subscriber
- Yearly ($49.99): You receive **$48.20** per subscriber

### Withdrawal
- Free to your bank account
- 1-3 business days processing

---

## Managing Subscriptions

### View Subscribers
1. Log into PayPal
2. Go to **"Activity"**
3. Filter by **"Subscriptions"**
4. See all active subscribers

### Cancel a Subscription
1. Find subscription in Activity
2. Click **"Cancel"**
3. User loses access at end of billing period

### Refunds
1. Go to Activity
2. Find transaction
3. Click **"Refund"**
4. Enter amount
5. Confirm refund

---

## Webhooks (Optional - Advanced)

To receive real-time notifications:

### 5.1 Set Up Webhook
1. Go to https://developer.paypal.com/dashboard/
2. Click **"Webhooks"**
3. Click **"Add Webhook"**
4. Webhook URL: `https://your-backend.com/api/paypal-webhook`
5. Select events:
   - `BILLING.SUBSCRIPTION.ACTIVATED`
   - `BILLING.SUBSCRIPTION.CANCELLED`
   - `BILLING.SUBSCRIPTION.SUSPENDED`
   - `BILLING.SUBSCRIPTION.UPDATED`
   - `PAYMENT.SALE.COMPLETED`

### 5.2 Verify Webhook
PayPal will send test events to verify your endpoint.

---

## Troubleshooting

### "PayPal button not showing"
- Check Client ID is correct
- Verify Plan IDs are correct
- Check browser console for errors
- Ensure internet connection

### "Payment declined"
- Insufficient funds
- Card expired
- Bank declined transaction
- Try different payment method

### "Subscription not activating"
- Check `onApprove` function in code
- Verify localStorage is enabled
- Check browser console for errors

---

## Support

### PayPal Support
- Help Center: https://www.paypal.com/help
- Phone: 1-888-221-1161
- Email: Via help center

### Testing Resources
- Sandbox: https://developer.paypal.com/dashboard/
- Test cards: https://developer.paypal.com/tools/sandbox/card-testing/

---

## Checklist

Before going live:

- [ ] PayPal Business account created
- [ ] Identity verified
- [ ] Bank account linked
- [ ] Client ID obtained
- [ ] Monthly plan created
- [ ] Yearly plan created
- [ ] Plan IDs copied
- [ ] Code updated with real IDs
- [ ] Tested in sandbox mode
- [ ] Tested live payment
- [ ] Subscription activates correctly
- [ ] Premium features unlock
- [ ] Deployed to production

---

## Next Steps

After setup:
1. ✅ Test both subscription plans
2. ✅ Verify premium features activate
3. ✅ Monitor first payments in PayPal dashboard
4. ✅ Set up email notifications for new subscribers
5. ✅ Create cancellation policy page

---

**Status:** Ready to accept payments!  
**Setup time:** 20-30 minutes  
**Monthly cost:** $0 (only transaction fees)  
**Revenue potential:** Unlimited!  

🚀 **Your site is now a real subscription business!**
