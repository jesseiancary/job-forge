# FinTech & HealthTech Positioning Reference

This reference guide provides industry-specific terminology, concepts, and positioning strategies for FinTech and HealthTech roles.

## FinTech Domain Expertise

### Payment Systems Terminology

**Core Concepts**:
- **Payment Orchestration**: Managing multiple payment gateways, routing logic, failover
- **Payment Rails**: Infrastructure for moving money (card networks, ACH, wire transfers)
- **Merchant Services**: Tools and platforms for businesses to accept payments
- **Settlement**: Process of transferring funds from payer to payee after authorization
- **Reconciliation**: Matching transaction records across systems for financial accuracy
- **Clearing**: Final exchange of payment information between financial institutions

**Transaction Flow**:
- **Authorization**: Checking if funds are available and reserving them
- **Capture**: Actually charging the customer after authorization
- **Refund/Void**: Reversing a transaction (before/after settlement)
- **Chargeback**: Customer disputes requiring merchant to return funds

**Security & Compliance**:
- **PCI DSS**: Payment Card Industry Data Security Standard (Levels 1-4)
- **PCI DSS Level 1**: Highest compliance tier (>6M card transactions/year)
- **Tokenization**: Replacing sensitive card data with non-sensitive tokens
- **3DS (3D Secure)**: Additional authentication layer for online card transactions
- **Card-Not-Present (CNP)**: Transactions without physical card (higher fraud risk)
- **DPAN/FPAN**: Device/Funding Primary Account Number (tokenization schemes)

**Fraud & Risk**:
- **KYC (Know Your Customer)**: Identity verification requirements
- **AML (Anti-Money Laundering)**: Regulations to prevent financial crimes
- **Fraud Detection**: Systems like Kount, Sift, Stripe Radar
- **Risk Scoring**: Assigning risk levels to transactions/merchants
- **Velocity Checks**: Monitoring transaction frequency for anomalies

**Payment Methods**:
- **Card Networks**: Visa, Mastercard, Amex, Discover
- **Digital Wallets**: Apple Pay, Google Pay, PayPal, Venmo
- **ACH**: Automated Clearing House (bank-to-bank transfers in US)
- **Wire Transfer**: Direct bank-to-bank transfer (typically for larger amounts)
- **SEPA**: Single Euro Payments Area (European equivalent of ACH)

**Merchant/Partner Concepts**:
- **Merchant Account**: Business account for accepting card payments
- **Payment Gateway**: Service connecting merchant to payment processor
- **Payment Processor**: Company handling transaction processing
- **Acquiring Bank**: Bank that processes card payments for merchant
- **Issuing Bank**: Bank that issued the customer's card
- **PSP (Payment Service Provider)**: All-in-one payment solution provider
- **Payfac (Payment Facilitator)**: Simplifies merchant onboarding by sub-merchant model
- **ISO (Independent Sales Organization)**: Third-party selling payment processing services

**Financial Data**:
- **Ledger**: Record of all financial transactions
- **Double-Entry Accounting**: Every transaction affects two accounts
- **Idempotency**: Ensuring duplicate requests don't create duplicate charges
- **Eventual Consistency**: Accepting temporary data inconsistency for scalability
- **Financial Reporting**: Generating statements, tax documents, reconciliation reports

### Your FinTech Experience Translation

**Payment Platform Company (2021-2026)**:
- ✅ Integrated multiple payment gateways (Braintree, WorldPay, Clover)
- ✅ Processed $1B+ annually across 1.5M+ monthly transactions
- ✅ Maintained PCI DSS Level 1 compliance
- ✅ Built fraud detection integration (Kount 360, 34% fraud reduction)
- ✅ Implemented 3DS, Apple Pay/Google Pay tokenization
- ✅ Circuit breakers & failover routing for payment reliability
- ✅ 99.95% uptime on payment-critical flows
- ✅ Multi-tenant merchant portals with RBAC

**E-commerce Platform Company (2008-2019)**:
- ✅ Integrated payment gateways (Auth.net, PayEezy, PayPal)
- ✅ Maintained PCI DSS compliance for 11 years
- ✅ Processed 500K+ monthly e-commerce transactions
- ✅ Built partner/merchant onboarding workflows (85% faster)

### FinTech Language to Use in Applications

**Instead of...** | **Say...**
Payment integration | Payment orchestration, multi-gateway routing
Processing transactions | Transaction processing at scale, payment flows
Security | PCI DSS Level 1 compliance, financial data security
System reliability | 99.95% uptime on payment-critical flows
Data accuracy | Financial data integrity, reconciliation workflows
Partner onboarding | Merchant onboarding, partner integration

**Key Phrases**:
- "Payment orchestration across multiple gateways"
- "Financial transaction processing at scale"
- "PCI DSS Level 1 compliance-driven architecture"
- "Transaction integrity and reconciliation workflows"
- "Merchant services and partner integration"
- "Card network transaction flows"
- "Money movement with idempotency guarantees"
- "Settlement and clearing workflows"
- "Fraud detection and risk management"

---

## HealthTech Domain Readiness

### Healthcare Systems Terminology

**Core Concepts**:
- **EHR (Electronic Health Record)**: Digital patient medical records
- **EMR (Electronic Medical Record)**: Digital version of paper charts (specific to one practice)
- **PHI (Protected Health Information)**: Any health info that can identify a patient
- **ePHI**: Electronic PHI subject to HIPAA Security Rule
- **Clinical Workflows**: Processes for patient care delivery (intake → diagnosis → treatment → follow-up)
- **Care Coordination**: Managing patient care across multiple providers/settings
- **Telehealth**: Remote healthcare delivery via video/phone/messaging
- **Telemedicine**: Subset of telehealth focused on clinical care

**Compliance & Security**:
- **HIPAA (Health Insurance Portability and Accountability Act)**: US healthcare data privacy law
- **HITECH Act**: Strengthened HIPAA, added breach notification requirements
- **HIPAA Privacy Rule**: Governs use/disclosure of PHI
- **HIPAA Security Rule**: Technical safeguards for ePHI (similar to PCI DSS)
- **BAA (Business Associate Agreement)**: Required contract for vendors handling PHI
- **Minimum Necessary**: Only access/use PHI required for specific purpose
- **Audit Logs**: Required tracking of all PHI access
- **Breach Notification**: Required reporting of PHI data breaches

**Clinical & Administrative**:
- **Provider**: Healthcare professional (doctor, nurse practitioner, therapist, etc.)
- **Patient Portal**: Patient-facing system for medical records, appointments, messaging
- **Provider Portal**: Clinician-facing system for patient management, charting, ordering
- **Clinical Decision Support (CDS)**: Tools helping providers make clinical decisions
- **CPOE (Computerized Provider Order Entry)**: Electronic ordering of medications/tests
- **e-Prescribing**: Electronic prescription sending to pharmacies
- **Prior Authorization**: Insurance approval required before certain treatments
- **Care Plan**: Personalized treatment plan for patient

**Interoperability Standards**:
- **HL7 (Health Level 7)**: Messaging standard for exchanging clinical data
- **FHIR (Fast Healthcare Interoperability Resources)**: Modern API-based HL7 standard
- **CCD (Continuity of Care Document)**: Standard format for patient summary
- **CCDA**: XML-based implementation of CCD
- **ICD-10**: Diagnosis coding system
- **CPT**: Procedure coding system
- **SNOMED CT**: Clinical terminology system
- **LOINC**: Lab observation identifiers

**Healthcare Operations**:
- **Intake**: Patient registration and information collection
- **Eligibility**: Checking if patient's insurance covers service
- **Clinical Encounter**: Patient-provider interaction (visit)
- **Charting**: Provider documenting clinical notes
- **Orders**: Lab tests, prescriptions, imaging, referrals
- **Results**: Lab/imaging results returned to provider
- **Billing**: Generating claims to insurance/patient
- **Claims Adjudication**: Insurance processing and payment decision

### PCI DSS → HIPAA Compliance Translation

**Your PCI DSS Experience** | **HIPAA Equivalent**
---|---
Cardholder data protection | PHI protection
Access controls, RBAC | Minimum necessary access, role-based permissions
Audit logging | PHI access audit trails
Encryption in transit/at rest | ePHI encryption requirements
Vulnerability scanning | Risk analysis and management
Regular security audits | HIPAA Security Rule compliance audits
Multi-tenant isolation | Patient data isolation
PCI DSS Level 1 (strictest) | HIPAA Security Rule compliance rigor

### Your HealthTech Experience Translation

**Payment Platform Company (2021-2026)** → **HealthTech Parallels**:
- ✅ PCI DSS Level 1 compliance → HIPAA compliance rigor
- ✅ Sensitive payment data → PHI handling
- ✅ Multi-tenant RBAC (1,000+ users) → Provider/clinician portals
- ✅ 95% reduction in unauthorized access → PHI access controls
- ✅ Real-time WebSocket notifications → Clinical alerts
- ✅ Integration with third-party systems (OAuth 2.0) → EHR/EMR integrations (HL7/FHIR)
- ✅ 99.95% uptime on critical flows → Patient safety, care continuity
- ✅ Audit trails and monitoring → HIPAA audit logging requirements
- ✅ 2,000+ locations → Multi-clinic/hospital network platforms
- ✅ 55% wait time reduction → Patient experience optimization

### HealthTech Language to Use in Applications

**Instead of...** | **Say...**
Payment data | PHI (Protected Health Information), patient data
Merchant portal | Provider portal, clinician portal
PCI DSS compliance | HIPAA compliance, healthcare-grade security
System uptime | Patient safety, care continuity
Transaction notifications | Clinical alerts, care coordination notifications
Integration complexity | EHR/EMR integration, HL7/FHIR interoperability
Multi-location system | Multi-clinic network, hospital system platform

**Key Phrases**:
- "Healthcare-grade security and compliance"
- "PCI DSS Level 1 compliance rigor directly applicable to HIPAA"
- "Sensitive data handling: payment data → PHI"
- "Multi-tenant RBAC for provider and clinician access"
- "99.95% uptime = patient safety and care continuity"
- "Clinical workflows and care delivery platforms"
- "EHR/EMR integration readiness (HL7/FHIR standards)"
- "Audit trails for regulatory compliance"
- "Real-time clinical alerts and care coordination"
- "Patient-facing and provider-facing platforms"

---

## Senior/Staff Engineer Positioning

### Senior vs Staff Distinction

**Senior Engineer**:
- Deep technical expertise in specific domain
- Leads projects and mentors engineers
- Makes architectural decisions for their team/domain
- 5-10+ years experience typical

**Staff Engineer**:
- Broad technical expertise across multiple domains
- Influences multiple teams, cross-functional leadership
- Makes company-wide architectural decisions
- Sets technical strategy and standards
- 10-15+ years experience typical
- Leadership without direct reports

**You**: 17 years experience = Senior to Staff level contributor

### Key Talking Points for Senior/Staff Roles

**Architectural Ownership**:
- "Designed and implemented TypeScript monorepo architecture"
- "Defined patterns for end-to-end type safety across schema → API → UI"
- "Established engineering standards for code quality and review practices"
- "Made architectural trade-offs balancing velocity, reliability, and maintainability"

**System Design at Scale**:
- "Scaled systems from 250 to 2,000+ locations (8x growth)"
- "Grew transaction volume from 100K to 1.5M+ monthly (15x growth)"
- "Maintained 99.95% uptime while processing $1B+ annually"
- "Database optimization reducing load by 60%, API responses 45% faster"

**Technical Leadership**:
- "Partnered with CEO, CTO, and product stakeholders to define technical strategy"
- "Mentored 8+ engineers over 11 years, reducing defects 45%, onboarding time 6→2 weeks"
- "Established code review practices and Git workflows as engineering culture standards"
- "Influenced engineering decisions across frontend, backend, and infrastructure"

**Long-Term Thinking**:
- "Patterns I set compound over time—the next engineer reaches for them"
- "Systems that hold up over time require thoughtful upfront design"
- "11-year tenure at e-commerce company, 5 years at payment platform = sustained impact"

---

## Resume & Cover Letter Strategies

### For FinTech Roles

**Professional Summary**:
- Lead with "17 years building payment systems and financial transaction processing platforms"
- Emphasize: $1B+ payment volume, PCI DSS Level 1, payment gateways by name
- Include: Fraud detection, 99.95% uptime, transaction integrity

**Experience Bullets (Priority Order)**:
1. Payment gateway integrations (Braintree, WorldPay, Clover)
2. Financial transaction volume ($1B+, 1.5M+ monthly)
3. PCI DSS Level 1 compliance
4. Fraud detection (Kount 360, 34% reduction)
5. System reliability (99.95% uptime, circuit breakers)

**Cover Letter**:
- Opening: Connect their payment/financial product to your 17 years of payment experience
- Body: Emphasize money movement, transaction integrity, merchant onboarding
- Closing: "17 years of payment systems expertise ready to apply to [their mission]"

### For HealthTech Roles

**Professional Summary**:
- Lead with "17 years building secure, compliant systems for sensitive data processing"
- Emphasize: PCI DSS → HIPAA parallels, multi-tenant RBAC, 99.95% uptime
- Include: Healthcare-grade reliability, audit trails, integration readiness

**Experience Bullets (Priority Order)**:
1. PCI DSS Level 1 compliance (healthcare-grade compliance rigor)
2. Multi-tenant RBAC (1,000+ users, 95% unauthorized access reduction)
3. Integration with third-party systems (OAuth 2.0, REST APIs)
4. 99.95% uptime (patient safety parallel)
5. Audit trails and security monitoring

**Cover Letter**:
- Opening: Connect their healthcare mission to systems where reliability = patient safety
- Body: Emphasize PCI → HIPAA, clinical workflows, provider portals
- Closing: "Compliance-driven engineering experience ready to apply to healthcare systems"

### For Senior/Staff Roles

**Professional Summary**:
- Lead with "17 years leading architectural decisions, mentoring teams, building high-scale systems"
- Emphasize: System design at scale, technical strategy, engineering standards
- Include: Cross-functional collaboration, long-term impact

**Experience Bullets (Priority Order)**:
1. Architectural decisions (TypeScript monorepo, design patterns)
2. Scaling metrics (250 → 2,000+ locations, 100K → 1.5M+ transactions)
3. Cross-functional collaboration (CEO, executives, product)
4. Mentorship (8+ engineers, 45% defect reduction, 6→2 week onboarding)
5. System design trade-offs (reliability vs velocity)

**Cover Letter**:
- Opening: Connect their technical challenge to your 17 years of senior technical work
- Body: Emphasize architectural decisions, patterns that compound, long-term thinking
- Closing: "Senior technical leadership ready to help [scale/define/establish] [their challenge]"

---

## Common Mistakes to Avoid

### FinTech Applications
❌ Saying "handled payments" instead of "payment orchestration"
❌ Missing PCI DSS Level 1 specification (Level 1 = highest tier)
❌ Not mentioning specific gateways by name (Braintree, WorldPay, etc.)
❌ Ignoring fraud/risk management experience
❌ Generic "financial systems" without transaction volume metrics

### HealthTech Applications
❌ Not making PCI → HIPAA connection explicit
❌ Saying "medical data" instead of "PHI"
❌ Missing patient safety angle for 99.95% uptime
❌ Not mentioning EHR/EMR integration readiness
❌ Generic "healthcare" without clinical workflow language

### Senior/Staff Applications
❌ Only listing technologies without architectural context
❌ Missing cross-functional collaboration
❌ No mention of design docs, RFCs, or technical strategy
❌ Focusing on implementation details instead of decisions
❌ Not emphasizing long-term impact (tenure, sustained growth)

---

## Quick Reference Cheat Sheet

### Your Core Strengths for FinTech
✅ 16+ years payment systems experience
✅ $1B+ annual payment volume
✅ PCI DSS Level 1 compliance (both roles)
✅ Multiple payment gateway integrations
✅ Fraud detection (Kount 360, 34% reduction)
✅ 99.95% uptime on payment-critical systems
✅ Transaction integrity at scale

### Your Core Strengths for HealthTech
✅ PCI DSS Level 1 = healthcare-grade compliance
✅ Multi-tenant RBAC (1,000+ users, 95% access reduction)
✅ 99.95% uptime = patient safety
✅ Complex third-party integrations (OAuth 2.0, REST)
✅ Audit trails and security monitoring
✅ Real-time notifications (clinical alerts parallel)
✅ Multi-location systems (2,000+ sites)

### Your Core Strengths for Senior/Staff
✅ 17 years experience
✅ Architectural ownership (TypeScript monorepo, patterns)
✅ System design at scale (8x location growth, 15x transaction growth)
✅ Technical leadership (CEO/CTO partnerships, mentored 8+)
✅ Engineering standards (45% defect reduction, 6→2 week onboarding)
✅ Long tenure (11 years + 5 years) = sustained impact
✅ Cross-functional influence
