# Decentralized Prescription Drug Monitoring Program (dPDMP)

A blockchain-based solution for secure, transparent, and efficient monitoring of controlled substance prescriptions.

## Overview

The Decentralized Prescription Drug Monitoring Program (dPDMP) leverages blockchain technology to create a tamper-proof, interoperable system for tracking controlled substance prescriptions across healthcare providers and pharmacies. This system aims to prevent prescription drug abuse, reduce doctor shopping, and provide healthcare professionals with real-time access to comprehensive patient prescription histories.

## System Architecture

The dPDMP consists of four primary smart contracts:

1. **Prescriber Verification Contract**
    - Validates and maintains records of authorized healthcare providers
    - Manages prescriber credentials and permissions
    - Interfaces with existing medical licensing databases

2. **Pharmacy Verification Contract**
    - Confirms and tracks legitimate dispensing facilities
    - Manages pharmacy credentials and permissions
    - Integrates with pharmacy licensing systems

3. **Prescription Tracking Contract**
    - Records and monitors all controlled substance prescriptions
    - Maintains patient prescription histories with privacy safeguards
    - Enables secure cross-reference of prescription data

4. **Alert System Contract**
    - Analyzes prescription patterns to identify potential abuse
    - Flags unusual prescribing or filling behaviors
    - Generates notifications for healthcare providers and regulatory bodies

## Key Features

- **Privacy-Preserving**: Implements robust encryption and access controls to protect patient data
- **Interoperable**: Designed to work across different healthcare systems and state boundaries
- **Immutable Record-Keeping**: Creates tamper-proof prescription records
- **Real-Time Monitoring**: Provides immediate access to up-to-date prescription information
- **Regulatory Compliance**: Built to meet HIPAA and other relevant healthcare regulations

## Getting Started

### Prerequisites

- Node.js v16+
- Truffle framework
- Ganache (for local development)
- Web3.js
- Metamask or similar Ethereum wallet

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-organization/dpdmp.git
   cd dpdmp
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Compile the smart contracts:
   ```
   truffle compile
   ```

4. Deploy to local development blockchain:
   ```
   truffle migrate --network development
   ```

### Configuration

1. Configure the network settings in `truffle-config.js` for your target deployment network
2. Set up environment variables for API keys and sensitive configuration
3. Adjust access control settings based on your regulatory requirements

## Usage

### For Healthcare Providers

```javascript
// Example: Prescriber verifying their credentials
const prescriberContract = await PrescriberVerification.deployed();
await prescriberContract.registerPrescriber(licenseNumber, credentials, publicKey);

// Example: Creating a new prescription
const prescriptionContract = await PrescriptionTracking.deployed();
await prescriptionContract.createPrescription(patientId, medicationCode, dosage, quantity, refills);
```

### For Pharmacies

```javascript
// Example: Pharmacy verifying their credentials
const pharmacyContract = await PharmacyVerification.deployed();
await pharmacyContract.registerPharmacy(pharmacyLicense, credentials, publicKey);

// Example: Filling a prescription
const prescriptionContract = await PrescriptionTracking.deployed();
await prescriptionContract.fillPrescription(prescriptionId, pharmacyId, filledQuantity, fillDate);
```

### For Regulators

```javascript
// Example: Setting up monitoring parameters
const alertContract = await AlertSystem.deployed();
await alertContract.configureAlertThresholds(medicationClass, timeframeInDays, prescriptionLimit);

// Example: Accessing alert reports
const alerts = await alertContract.getAlerts(fromDate, toDate, severity);
```

## Security Considerations

- **Key Management**: Secure storage and management of private keys is critical
- **Smart Contract Auditing**: Regular security audits recommended
- **Access Controls**: Granular permissions system to ensure appropriate data access
- **Encryption**: End-to-end encryption for all sensitive patient data
- **Compliance**: Regular reviews to ensure compatibility with evolving regulations

## Testing

Run the test suite to verify contract functionality:

```
truffle test
```

Test coverage includes:
- Prescriber verification flows
- Pharmacy registration and validation
- Prescription lifecycle management
- Alert generation and notification

## Deployment

### Testnet Deployment

For testing on Ethereum testnets:

```
truffle migrate --network ropsten
```

### Production Deployment

For deploying to production networks:

```
truffle migrate --network mainnet
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Project Link: [https://github.com/your-organization/dpdmp](https://github.com/your-organization/dpdmp)

## Acknowledgments

- OpenZeppelin for secure smart contract libraries
- Healthcare standards organizations for interoperability guidelines
- Regulatory advisors for compliance guidance
