# Cover Letter Generation Guidelines

Use these guidelines to generate tailored cover letter body text for job applications.

## IMPORTANT: Conciseness Guidelines

**Target Total Length**: 250-300 words (3 paragraphs)
- **Paragraph 1**: 2-3 sentences (~50-60 words)
- **Paragraph 2**: 3-5 sentences (~80-100 words)
- **Paragraph 3**: 3-5 sentences (~80-100 words)

**Key Principles**:
- Be selective: Choose 2-3 MOST relevant achievements per paragraph
- Avoid listing everything - quality over quantity
- Each sentence should add value - cut filler words
- Aim for ~75% the length of verbose examples

## Template Structure

The cover letter template (`resumes/sample/cover-letter.tex`) has two placeholders:
1. **`COMPANY_NAME`** - Replace with actual company name (e.g., "TechCorp")
2. **`BODY_TEXT`** - Replace with generated 3 paragraph body (250-300 words)

## LaTeX Syntax Requirements

**IMPORTANT**: Follow LaTeX escaping rules from `.claude/skills/latex.md`:

- **Escape dollar signs**: `\$1B+` not `$1B+`
- **Use math mode for approximation**: `$\sim$250` for "~250"
- **Use math mode for comparison**: `$<$0.5\%` for "<0.5%"
- **Escape percentages**: `95\%` not `95%`
- **Use regular hyphens**: `-` not Unicode `‑` (U+2011)

**Reference**: See `.claude/skills/latex.md` for complete character escaping guide.

## Body Text Structure

**Target Length**: 3 paragraphs total, ~250-300 words (about 75% of previous length)

### Paragraph 1: Opening Hook (2-3 sentences, ~50-60 words)
**Purpose**: Establish immediate relevance and demonstrate understanding of the role

**Formula**:
```
I am applying for the [exact role title] role at [Company]. [1 sentence connecting
their product/mission to your relevant experience]. I have spent [timeframe] building
[type of systems] using [matching tech stack] to deliver [key outcomes].
```

**Keep it concise**:
- Lead with role title and company
- One sentence connecting their mission to your work
- One sentence with timeframe, tech stack, and outcomes
- Total: 2-3 sentences maximum

---

### Paragraphs 2-3: Experience Deep-Dive (3-5 sentences each, ~80-100 words each)
**Purpose**: Provide concrete evidence of relevant experience with metrics

**Important**: Be selective - choose the MOST relevant 3-4 accomplishments per paragraph, not everything

#### Paragraph 2: Recent Role (Current Company)
Always start with Payment Platform Company (2021-2026, 5 years)

**Formula** (3-5 sentences):
```
At [Company], I [led/built] [system] using [tech stack], [scale metric]. I [specific
achievement 1 with metric], [achievement 2 with metric], and [achievement 3 with metric].
[Optional leadership/collaboration sentence if relevant to role].
```

**Key**: Pick 2-3 MOST relevant achievements with metrics. Avoid listing everything.

**Customize based on role type (Prioritized by Target Industries)**:

**For Senior/Staff Roles** (Primary Target):
- Lead with: "led architectural decisions and technical strategy across X years"
- Emphasize: System design at scale (250→2,000+ locations, 100K→1.5M+ transactions)
- Include leadership: Partnered with CEO/executives, mentored 8+ engineers
- Architectural ownership: Defined patterns for TypeScript monorepo, established engineering standards
- Mention: Design docs, RFC processes, technical trade-offs, incident response
- Impact metrics: 45% defect reduction, 6→2 week onboarding, 99.95% uptime SLAs
- Reference: Long-term thinking ("systems that hold up over time", "patterns the next engineer reaches for")
- Show influence: Leadership without direct reports, technical vision setting

**For Payment/FinTech Roles** (Primary Target):
- Lead with payment gateway integration: "integrated Braintree as our primary payment gateway"
- Emphasize: Financial transaction processing ($1B+ annual, 1.5M+ monthly transactions)
- PCI DSS Level 1 compliance, SOC 2 readiness
- Fraud detection & risk management: Kount 360, OAuth 2.0, 34% fraud reduction
- Money movement: 3DS authentication, Apple Pay/Google Pay tokenization, card network flows
- Transaction integrity: Idempotency, reconciliation, financial data accuracy
- System reliability: 99.95% uptime, circuit breakers, failover routing
- Partner integration: 85% faster merchant onboarding (3-4 weeks → 3-5 days)
- Language to use: "payment orchestration", "settlement flows", "merchant services", "financial compliance"

**For Healthcare/MedTech Roles** (Primary Target):
- Lead with: "building secure, compliant systems for sensitive data processing"
- Emphasize PCI DSS → HIPAA parallel: "compliance rigor directly applicable to HIPAA requirements"
- Frame: "sensitive payment data" → "PHI (Protected Health Information)"
- Multi-tenant with strict access controls: 1,000+ users, 95% unauthorized access reduction
- Integration readiness: Payment gateways → EHR/EMR systems (mention HL7/FHIR readiness)
- Patient safety parallel: 99.95% uptime = systems patients depend on in real time
- Real-time notifications: Transaction status → clinical alerts
- Audit trails, security monitoring, regulatory compliance
- Multi-location: 2,000+ payment sites → clinic/hospital networks
- Language to use: "clinical workflows", "care delivery", "patient safety", "provider portals", "healthcare-grade reliability"

**For Backend Roles**:
- Lead with: "led backend architecture and development using Node.js, Express, and MongoDB"
- Emphasize: API design (OpenAPI, Zod), database optimization, circuit breakers, failover routing
- Include: Payment gateway integrations (Braintree primary, also WorldPay, Clover)
- Metrics: 99.95% uptime, 60% database load reduction, 45% faster APIs

**For Full-Stack Roles**:
- Lead with: "led full-stack development using Angular, TypeScript, Node.js, and MongoDB"
- Emphasize: Multi-tenant admin portal, RBAC, end-to-end type safety, WebSocket notifications
- Include: Partnering with CEO/product stakeholders
- Metrics: 250→2,000+ locations, 100K→1.5M transactions, 99.95% uptime

**For Startup Roles**:
- Emphasize: "Working directly with the CTO and CEO"
- Include: "early-stage" or "startup" language
- Highlight: Wearing multiple hats, end-to-end ownership, fast pace
- Add: AI tools (Claude Code, Cursor, GitHub Copilot, 3x-5x velocity)

#### Paragraph 3: Earlier Roles (Mining Software + E-commerce Platform)

**Formula** (3-5 sentences, ~80-100 words):
```
At [E-commerce Company], I [owned/built] [key system] as sole developer alongside the CTO,
[scale metric]. I [achievement 1 with metric], [achievement 2 with metric], and mentored
[X] engineers, [outcome metric].
```

**Key Guidelines**:
- Focus on e-commerce company (11 years, more substantial)
- Mention mining company only if React experience is highly relevant
- Pick 2-3 MOST relevant achievements
- Include mentorship if targeting senior+ roles

**Example (Concise)**:
```
At E-commerce Platform Company, I owned backend architecture as sole developer alongside the CTO,
processing 500K+ monthly orders. I built integration tooling that reduced partner onboarding by
85% (3-4 weeks to 3-5 days), migrated the platform to AWS achieving 99.98% uptime, and mentored
eight engineers, cutting onboarding time from 6 weeks to 2 weeks.
```

---

### Paragraph 3 (Alternative): Closing Paragraph (2-3 sentences, ~50-60 words)
**Purpose**: Connect experience to company mission, show enthusiasm

**Use closing paragraph instead of earlier roles paragraph if**:
- Earlier roles are less relevant
- You want to emphasize culture fit over experience breadth
- Cover letter is getting too long

**Formula** (2-3 sentences):
```
[I thrive in / Throughout my career, I have built] [type of systems/environments]. [Company]'s
[mission/product] requires that same [quality], and I am ready to bring [your strength] to
[their specific challenge/team].
```

**Customize based on company type (Prioritized by Target Industries)**:

**FinTech/Payment Companies** (Primary Target):
```
I have built financial systems where accuracy and compliance are non-negotiable—processing
$1B+ annually while maintaining PCI DSS Level 1 compliance and 99.95% uptime. [Company]'s
[payment platform/financial infrastructure] requires that same rigor, and I am ready to
bring 17 years of payment systems expertise to [their specific challenge].
```

**HealthTech Companies** (Primary Target):
```
Building payment systems at scale taught me that reliability, security, and compliance aren't
optional. The patterns I've established for PCI DSS Level 1 compliance and 99.95% uptime
translate directly to HIPAA requirements and patient safety. I am ready to apply this
compliance-driven engineering experience to [Company]'s [healthcare platform/mission].
```

**Senior/Staff Engineer Roles** (Any Domain):
```
The most consequential engineering work is defining patterns and making architectural decisions
that compound over time. I scaled systems from 250 to 2,000+ locations by making thoughtful
trade-offs between velocity and reliability. I am ready to bring this long-term thinking to
[Company]'s [technical challenge/platform].
```

**Mission-Driven Companies** (healthcare, social impact):
```
I have built systems where performance and reliability are non-negotiable—processing $1B+
annually at 99.95% uptime. [Company]'s mission of [their mission] requires that same rigor,
and I am eager to bring that to [their platform/team].
```

**Technical/Craft-Driven Companies** (engineering-focused startups):
```
The patterns I set in a TypeScript monorepo become the patterns the next engineer reaches for.
After five years building similar systems, I know what it takes to make those patterns hold up
over time, and I am ready to help [Company] [build/scale/establish] [their technical challenge].
```

**High-Velocity Startups**:
```
I thrive in high-velocity environments and am eager to bring [their new technology] into my
toolkit. [Company]'s commitment to [their value] aligns with my approach to engineering, and
I am ready to help [their product/platform] [their goal].
```

**Established Companies / Large Scale**:
```
I have spent much of my career turning complex business processes—payments, [other relevant
domain], fraud detection—into systems that just work at scale. [Company]'s [product/platform]
requires that same [quality], attention to detail, and [second quality], at scale and with
real consequences for [their customers/users].
```

**Final sentence** (choose one):
- "I would welcome the opportunity to discuss how I can contribute to [Company]'s [team/platform/growth]."
- "I am eager to bring this experience to [Company] and help [specific goal from JD]."
- "I would welcome the opportunity to discuss how I can help [specific outcome they mentioned]."

---

## Analysis Process

### Step 1: Extract Key Information from Job Description

Look for:
1. **Exact role title** - Use verbatim in opening
2. **Company mission/values** - Quote or paraphrase in closing
3. **Technology stack** - Match in paragraphs 2-3
4. **Key responsibilities** - Address in experience sections
5. **Scale/impact metrics** - Match with your metrics
6. **Team structure** - Mention if they emphasize collaboration
7. **Company stage** - Adjust tone (startup vs established)
8. **Domain** - Healthcare, payments, SaaS, etc.

### Step 2: Determine Emphasis Areas

Based on role type (reference `.claude/skills/job-application-helper.md`):
- **Full-Stack**: End-to-end ownership, multi-tenant systems, RBAC, TypeScript monorepo
- **Backend**: API design, database optimization, performance, reliability, integrations
- **Healthcare**: Compliance, sensitive data, integration complexity, security
- **Payment/FinTech**: Payment gateways, PCI DSS, fraud detection, transaction scale
- **Startup**: Early-stage ownership, fast pace, AI velocity, wearing multiple hats
- **Senior/Staff**: Mentorship, architecture, stakeholder collaboration, long-term impact

### Step 3: Select Matching Metrics

Choose 4-6 metrics that best align with the role. See [.claude/skills/job-application-helper.md](.claude/skills/job-application-helper.md) for the complete metrics reference.

### Step 4: Match Their Language

Copy exact phrases from the JD:
- If they say "telehealth workflows", use "telehealth workflows" (not "telemedicine")
- If they say "end-to-end ownership", use "end-to-end ownership"
- If they say "vertical slices", use "vertical slices"
- If they emphasize "mission", talk about mission
- If they emphasize "craft", talk about engineering excellence

---

## Quality Checklist

Before finalizing, ensure the cover letter:

- [ ] Uses exact role title from JD
- [ ] Mentions company mission/product specifically (not generic)
- [ ] Includes 4-6 relevant metrics
- [ ] Matches their technology stack
- [ ] Uses their language/phrases
- [ ] Addresses their key responsibilities
- [ ] Shows understanding of their domain
- [ ] Appropriate tone for company culture
- [ ] 3-4 paragraphs (not including salutation/closing)
- [ ] No generic phrases ("I am passionate about...")
- [ ] No typos or grammar errors
- [ ] Uses regular hyphens (-) not non-breaking hyphens (‑)
- [ ] Dollar signs properly escaped (\$1B+ not $1B+)
- [ ] Percentages escaped (95\% not 95%)
- [ ] Approximations use math mode ($\sim$250 not ~250)
- [ ] Ends with appropriate closing sentence

---

## Examples by Company Type

### Example 1: Full-Stack FinTech (Payment Platform/Financial Infrastructure)

```
I am applying for the Senior Full Stack Engineer role at [Company Name]. Building payment
infrastructure that merchants depend on requires end-to-end ownership—from gateway
integrations and fraud detection through admin dashboards and real-time transaction
monitoring—and I have spent the past five years doing exactly that. I led full-stack
development at Payment Platform Company using TypeScript, Angular, Node.js, and MongoDB,
scaling payment flows to process \$1B+ annually across 2,000+ locations while maintaining
PCI DSS Level 1 compliance and 99.95\% uptime.

At Payment Platform Company, I integrated Braintree as our primary payment gateway and built
full-stack systems supporting 1.5M+ monthly transactions with strict financial compliance
requirements. I designed RESTful APIs with OpenAPI contracts and Zod validation, built a
multi-tenant admin portal with role-based access controls serving 1,000+ users, and
integrated fraud detection (Kount 360 via OAuth 2.0) that reduced chargebacks by 34\%. I
implemented 3DS authentication flows, Apple Pay/Google Pay tokenization, and real-time
WebSocket notifications using Socket.io to keep merchants informed during critical payment
workflows. I maintained 99.95\% uptime through circuit breakers, retries, and failover
routing, ensuring financial transaction integrity through idempotency patterns and
reconciliation workflows.

At E-commerce Platform Company, I owned backend architecture as sole developer alongside the CTO,
processing 500K+ monthly orders. I integrated multiple payment gateways (Auth.net, PayEezy,
PayPal), maintained PCI DSS compliance through regular security audits and vulnerability
scans, and built integration tooling that reduced partner onboarding by 85\% (3-4 weeks to
3-5 days). I migrated the platform to AWS achieving 99.98\% uptime and mentored eight
engineers, cutting onboarding time from 6 weeks to 2 weeks.

I have built financial systems where accuracy, compliance, and reliability are
non-negotiable—processing \$1B+ annually while maintaining PCI DSS Level 1 compliance. [Company
Name]'s [payment platform/financial infrastructure] requires that same rigor and full-stack
ownership, and I am ready to bring 17 years of payment systems expertise to [their specific
challenge].

I would welcome the opportunity to discuss how I can contribute to [Company Name]'s platform.
```

### Example 2: Healthcare Full-Stack (Generic Healthcare Company)

```
I am applying for the Staff Fullstack Engineer role on the Clinic Platform team. Building
the systems that power telehealth workflows—from patient intake and eligibility through
prescribing, care plans, and follow-ups—requires the same end-to-end ownership and
integration complexity I have navigated throughout my career. I have spent the past five
years building fullstack systems at scale, integrating payment processors, fraud detection
platforms, and fulfillment systems while maintaining strict compliance requirements, and I
am ready to apply that experience to the clinical pathways that are redefining weight health
care.

At Payment Platform Company, I built and scaled fullstack systems using React, Angular,
TypeScript, Node.js, Express, and MongoDB, growing payment flows from approximately 250 to
2,000+ locations and monthly transactions from approximately 100K to over 1.5M while
maintaining PCI DSS Level 1 compliance. I designed RESTful APIs with OpenAPI contracts and
Zod schema validation, built a multi-tenant admin portal with role-based access controls
serving 1,000+ clinician-like users, and integrated third-party systems including WorldPay,
Clover, and Kount fraud detection via OAuth 2.0. I maintained 99.95% uptime on critical
payment flows through circuit breakers, retries, and failover routing, and implemented
real-time WebSocket notifications using Socket.io to keep users informed during sensitive
transaction workflows.

At E-commerce Platform Company, I owned architecture end-to-end, migrating a legacy platform to AWS
(EC2, RDS, S3, Route53) while building Node.js REST APIs and normalized SQL Server schemas
that processed 500K+ monthly orders. I integrated multiple payment gateways (Auth.net,
PayEezy, PayPal), maintained PCI DSS compliance through regular vulnerability scans and
security audits, and built integration tooling that reduced third-party partner onboarding
from weeks to days. I also mentored eight junior engineers over an 11-year tenure,
establishing code review practices and Git workflows that reduced defects by 45% and cut
onboarding time from six weeks to two weeks.

Throughout my career, I have built systems where performance, reliability, and security are
not optional—whether processing $1B+ in annual payments, maintaining PCI compliance, or
ensuring 99.95% uptime on flows that customers depend on in real time. [Company Name] is
blending clinical breakthroughs with digital-first community at a time when the science of
weight health is rapidly evolving, and I am eager to bring that same rigor, ownership, and
mentorship to the Clinic Platform team as you scale telehealth workflows that help millions
build sustainable healthy habits.

I would welcome the opportunity to discuss how I can contribute to the platform.
```

### Example 3: Technical/Craft-Driven (Generic Tech Company)

```
I am applying for the Senior Full Stack Engineer role at [Company Name]. I have spent the past
five years building and scaling a TypeScript monorepo at Payment Platform Company—
shipping vertical slices from Mongoose schema to Express API to Angular component with
end-to-end type safety holding each feature together. The opportunity to join mid-rebuild
and set architectural patterns for a clean-room TypeScript platform is exactly the kind of
foundational work I am looking for.

At Payment Platform Company, I led development of a TypeScript monorepo spanning Angular frontend, Node.js/
Express backend, and Mongoose/MongoDB data layer, scaling payment flows from approximately
250 to 2,000+ locations and monthly transactions from approximately 100K to over 1.5M. I
enforced end-to-end type safety using OpenAPI contracts, Zod schema validation, and strict
TypeScript configs—untyped boundaries and logic leaking into controllers bothered me then as
much as they would at [Company Name] now. I built a multi-tenant admin portal with role-based
access controls, designed permission-aware query layers, and shipped database schema changes,
API endpoints, and typed frontend forms in single PRs. Over the past year, I adopted Claude
Code, Cursor, and GitHub Copilot as force multipliers, accelerating feature delivery by 3x
to 5x while maintaining strict type boundaries and engineering hygiene.

Earlier at E-commerce Platform Company, I led a clean-room rebuild migrating a legacy platform to AWS,
designing Node.js REST APIs and normalized SQL Server schemas from scratch while the old
system processed 500K+ monthly orders. I owned architecture end-to-end as the sole full-stack
developer alongside the CTO, integrated payment gateways and fulfillment systems, and built
integration tooling that reduced partner onboarding from weeks to days. In my final year, we
transitioned the backend to TypeScript, establishing the patterns and migration strategy for
a monorepo architecture.

The patterns I set in a TypeScript monorepo—how schemas flow through validators, how modules
enforce narrow boundaries, how migrations preserve type safety—become the patterns the next
engineer reaches for. [Company Name]'s clean-room rebuild is the most consequential moment to join,
and after five years in a similar stack, I know exactly what it takes to make those patterns
hold up over time.

I would welcome the opportunity to discuss how I can contribute to the rebuild.
```

### Example 4: Backend Engineer (Generic Backend Role)

```
I am applying for the Senior Backend Engineer role at [Company Name]. I have spent the past
five years leading backend architecture and development at Payment Platform Company, building
Node.js/Express APIs and MongoDB schemas that scaled payment processing from approximately
250 to 2,000+ locations and monthly transactions from approximately 100K to over 1.5M while
maintaining 99.95\% uptime and PCI DSS Level 1 compliance.

At Payment Platform Company, I led backend development using Node.js, Express, and MongoDB,
integrating Braintree as our primary payment gateway to process \$1B+ annually. I designed
RESTful APIs with OpenAPI contracts and Zod schema validation, implemented circuit breakers
and failover routing to maintain 99.95\% uptime on critical payment flows, and optimized
database queries that reduced MongoDB load by 60\% and improved API response times by 45\%. I
integrated third-party systems including WorldPay, Clover, and Kount 360 fraud detection via
OAuth 2.0, implemented idempotency patterns for transaction integrity, and built real-time
notification systems using Socket.io and WebSocket connections. I also partnered with the CEO
and product stakeholders to define technical requirements and translate business needs into
scalable backend architecture.

At E-commerce Platform Company, I owned backend architecture as sole developer alongside the CTO,
building Node.js REST APIs and normalized SQL Server schemas that processed 500K+ monthly
orders. I integrated multiple payment gateways (Auth.net, PayEezy, PayPal), migrated the
platform to AWS (EC2, RDS, S3, Route53) achieving 99.98\% uptime, and built integration
tooling that reduced third-party partner onboarding by 85\% (3-4 weeks to 3-5 days). I also
mentored eight engineers over an 11-year tenure, establishing code review practices and Git
workflows that reduced defects by 45\% and cut onboarding time from 6 weeks to 2 weeks.

I have built backend systems where reliability, performance, and data integrity are
non-negotiable—processing \$1B+ in annual payments while maintaining 99.95\% uptime and strict
compliance requirements. I am ready to bring this backend expertise and architectural
ownership to [Company Name]'s [platform/team/challenge].

I would welcome the opportunity to discuss how I can contribute to [Company Name]'s backend
systems.
```

---

## Final Notes

- **Read the full job description carefully** - Don't skim
- **Use CLAUDE.md for context** - Reference experience summary and metrics
- **Match their energy** - Formal company = formal tone, casual startup = casual tone
- **Be specific** - Name technologies, use metrics, cite examples
- **Show, don't tell** - Instead of "I'm passionate", show passion through detailed knowledge
- **Keep it concise** - 3-4 paragraphs is enough, don't ramble
- **Proofread** - No typos, consistent formatting, proper company/product names
