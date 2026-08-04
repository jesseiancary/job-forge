# Cover Letter Generation Guidelines

**Generate tailored cover letters from scratch by analyzing the job description and synthesizing relevant experience into original prose. Use this guide for patterns and phrasing styles, not as templates to copy verbatim.**

---

## Overview & Philosophy

### Generation Approach: Analyze → Synthesize → Write

**DO:**
- Read and deeply analyze the job description
- Extract company names from the selected resume variant
- Select 4-6 most relevant achievements that match their needs
- Write fresh, original prose tailored to THIS specific role
- Use examples below as phrasing pattern references

**DON'T:**
- Copy example paragraphs and do find-replace on company names
- Use placeholder company names like "Payment Platform Company"
- List all achievements - be highly selective
- Write generic cover letters that could apply to any role

### Target Length

**Total**: 250-300 words (3 paragraphs)
- **Paragraph 1**: 2-3 sentences (~50-60 words) - Opening hook
- **Paragraph 2**: 3-5 sentences (~80-100 words) - Recent experience
- **Paragraph 3**: 3-5 sentences (~80-100 words) - Earlier experience OR closing

---

## Part 1: Analysis Phase

### Step 1: Extract Information from Job Description

**Read the JD carefully and note:**

1. **Exact role title** - Use verbatim in opening
2. **Company mission/values** - Reference in closing
3. **Technology stack** - Match in experience paragraphs
4. **Key responsibilities** - Address with relevant achievements
5. **Scale/impact signals** - Match with your metrics
6. **Team structure/culture** - Adjust tone accordingly
7. **Company stage** - Startup vs. established affects language
8. **Domain** - Healthcare, payments, SaaS, etc.

### Step 2: Extract Company Names from Resume Variant

**CRITICAL: Read the selected resume variant and extract ACTUAL company names.**

Do NOT use generic placeholders like "Payment Platform Company" or "E-commerce Platform Company".

**How to extract:**
1. Read `resumes/{variant}/resume.tex` file
2. Find all `\jobmeta{Title}{Company Name}{Dates}{Location}` entries
3. Extract the company names from the second parameter

**Example:**
If resume contains `\jobmeta{Senior Engineer}{Acme Corp}{2020--2025}{...}`, use "Acme Corp" in the cover letter.

Use these real company names when writing your cover letter.

### Step 3: Map Experience to Their Needs

**Select 4-6 achievements** that best demonstrate what they're looking for:
- Which metrics align with their scale?
- Which technologies match their stack?
- Which experiences address their key responsibilities?
- Which accomplishments show relevant domain expertise?

**Determine narrative arc:**
- What story are you telling across the three paragraphs?
- How does your experience build toward solving their challenge?

### Step 4: Determine Tone and Approach

Match their culture signals from the JD:

- **Mission-driven** → Emphasize impact, outcomes, user/customer benefit
- **Technical/craft-driven** → Emphasize architecture, patterns, engineering rigor
- **High-velocity startup** → Emphasize AI tools, ownership, speed, adaptability
- **Established/enterprise** → Emphasize scale, reliability, long-term systems

---

## Part 2: Generation Phase

### Paragraph 1: Opening Hook (2-3 sentences, ~50-60 words)

**Goal:** Connect their specific challenge to your relevant experience

**Structure:**
1. State role title and company name
2. Demonstrate understanding of their product/mission (use their language!)
3. Establish your relevant experience (timeframe, tech stack, key outcome)

**Phrasing Patterns:**

**Pattern A - Direct Connection:**
> "I am applying for the [exact role title] at [Company]. Building [their specific product/challenge] requires [quality they mentioned]—[expansion of that quality]—and I have spent [timeframe] doing exactly that."

**Pattern B - Mission Alignment:**
> "I am applying for the [exact role title] at [Company]. [Company]'s mission to [their mission] resonates deeply—I have spent [timeframe] building [type of systems] that [similar outcome]."

**Pattern C - Technical Fit:**
> "I am applying for the [exact role title] at [Company]. I have spent the past [timeframe] building [type of systems] using [matching tech stack], [key scale metric], and I am eager to bring that experience to [their specific challenge]."

**Examples of opening hooks:**

*FinTech:*
> "Building payment infrastructure that merchants depend on requires end-to-end ownership—from gateway integrations and fraud detection through admin dashboards and real-time transaction monitoring—and I have spent the past five years doing exactly that."

*HealthTech:*
> "Building systems where reliability and compliance aren't optional—whether processing payments or managing patient data—has been my career focus for 17 years."

*Startup/High-Velocity:*
> "I thrive in early-stage environments where one engineer owns vertical slices from schema to API to UI, and I am ready to bring that ownership mindset to [Company]."

*Technical/Craft:*
> "I have spent the past five years building and scaling a TypeScript monorepo—shipping vertical slices from Mongoose schema to Express API to Angular component with end-to-end type safety holding each feature together."

---

### Paragraph 2: Recent Experience (3-5 sentences, ~80-100 words)

**Goal:** Provide concrete evidence with metrics from most recent relevant role

**Structure:**
1. Lead with company name and brief role context
2. Select 3-4 MOST relevant achievements (not everything!)
3. Use metrics that match their scale/domain
4. Match their technology stack terminology
5. Optional: Add leadership/collaboration if relevant to role

**Be Selective - Quality Over Quantity:**
- Choose achievements that directly address their needs
- Don't list every accomplishment - pick the most relevant
- Each sentence should demonstrate a skill they're looking for

**Role-Specific Emphasis Patterns:**

**For Senior/Staff Roles:**
- Lead with architectural decisions: "led architectural decisions and technical strategy"
- Emphasize system design at scale: "scaled from 250 to 2,000+ locations"
- Include cross-functional leadership: "partnered with CEO, product stakeholders"
- Reference patterns/standards: "established engineering standards", "defined patterns for..."
- Show long-term thinking: "patterns that hold up over time"
- Impact metrics: "45% defect reduction", "6→2 week onboarding", "99.95% uptime SLAs"

**For Payment/FinTech Roles:**
- Lead with gateway integration: "integrated [Gateway Name] as our primary payment gateway"
- Financial transaction volume: "$1B+ annual, 1.5M+ monthly transactions"
- Compliance: "PCI DSS Level 1 compliance", "SOC 2 readiness"
- Fraud/risk: "Kount 360", "34% fraud reduction", "OAuth 2.0"
- Money movement: "3DS authentication", "Apple Pay/Google Pay tokenization"
- Transaction integrity: "idempotency patterns", "reconciliation workflows"
- Reliability: "99.95% uptime", "circuit breakers", "failover routing"
- Use language: "payment orchestration", "settlement flows", "merchant services"

**For Healthcare/MedTech Roles:**
- Lead with compliance parallel: "building secure, compliant systems for sensitive data"
- PCI → HIPAA connection: "compliance rigor directly applicable to HIPAA requirements"
- Frame data handling: "sensitive payment data" → "PHI (Protected Health Information)"
- Access controls: "multi-tenant with role-based access controls", "1,000+ users, 95% unauthorized access reduction"
- Integration readiness: mention "HL7/FHIR readiness" if applicable
- Patient safety parallel: "99.95% uptime on systems users depend on in real time"
- Real-time notifications: "transaction status" → "clinical alerts"
- Audit trails: "security monitoring", "regulatory compliance"
- Use language: "clinical workflows", "care delivery", "patient safety", "provider portals", "healthcare-grade reliability"

**For Backend Roles:**
- Lead with backend stack: "led backend architecture using Node.js, Express, MongoDB"
- API design: "RESTful APIs with OpenAPI contracts", "Zod schema validation"
- Database optimization: "60% database load reduction", "45% faster API response times"
- System reliability: "circuit breakers", "failover routing", "99.95% uptime"
- Performance: "Redis caching", "query optimization", "indexing strategies"

**For Full-Stack Roles:**
- Lead with full stack: "led full-stack development using [frontend], [backend], [database]"
- End-to-end ownership: "vertical slices from schema to API to UI"
- Type safety: "end-to-end type safety with OpenAPI contracts and Zod validation"
- Multi-tenant systems: "RBAC", "permission-aware queries"
- Real-time features: "WebSocket notifications", "Socket.io"
- Metrics: "250→2,000+ locations", "100K→1.5M transactions"

**For Startup Roles:**
- Early-stage ownership: "working directly with the CTO and CEO"
- Wearing multiple hats: "owned architecture end-to-end as sole developer"
- Fast pace: "high-velocity environment", "rapid iteration"
- AI tools: "Claude Code, Cursor, GitHub Copilot", "3x-5x velocity improvement"
- Scaling: "scaled from 250 to 2,000+ locations"

---

### Paragraph 3: Earlier Experience OR Closing (3-5 sentences, ~80-100 words)

**Choose One Approach:**

#### Approach A: Earlier Experience
**When to use:** Earlier roles demonstrate relevant breadth or key skills

**Structure:**
1. Lead with company name and brief context
2. Select 2-3 MOST relevant achievements from earlier role
3. Include mentorship if targeting senior+ roles
4. Keep it concise - focus on what adds to the narrative

**Example pattern:**
> "At [E-commerce Company], I owned backend architecture as sole developer alongside the CTO for [duration], processing [scale metric]. I [achievement 1 with metric], [achievement 2 with metric], and mentored [X] engineers, [outcome metric]."

**Focus on:**
- E-commerce platform role (11 years, more substantial)
- Mining role only if React/specific tech is highly relevant
- Achievements that complement current role (different angles)
- Mentorship/leadership for senior+ roles

#### Approach B: Mission/Culture Closing
**When to use:** Earlier roles less relevant, want to emphasize culture fit

**Structure:**
1. Connect broader experience themes to their mission
2. Reference their specific product/platform/challenge
3. Express eagerness to contribute

**Phrasing Patterns by Company Type:**

**FinTech/Payment:**
> "I have built financial systems where accuracy and compliance are non-negotiable—processing $1B+ annually while maintaining PCI DSS Level 1 compliance. [Company]'s [payment platform/financial infrastructure] requires that same rigor, and I am ready to bring 17 years of payment systems expertise to [their specific challenge]."

**HealthTech:**
> "Building payment systems at scale taught me that reliability, security, and compliance aren't optional. The patterns I've established for PCI DSS Level 1 compliance and 99.95% uptime translate directly to HIPAA requirements and patient safety. I am ready to apply this compliance-driven engineering experience to [Company]'s [healthcare platform/mission]."

**Senior/Staff (Any Domain):**
> "The most consequential engineering work is defining patterns and making architectural decisions that compound over time. I scaled systems from 250 to 2,000+ locations by making thoughtful trade-offs between velocity and reliability. I am ready to bring this long-term thinking to [Company]'s [technical challenge/platform]."

**Mission-Driven:**
> "I have built systems where performance and reliability are non-negotiable—processing $1B+ annually at 99.95% uptime. [Company]'s mission of [their mission] requires that same rigor, and I am eager to bring that to [their platform/team]."

**Technical/Craft-Driven:**
> "The patterns I set in a TypeScript monorepo—how schemas flow through validators, how modules enforce boundaries—become the patterns the next engineer reaches for. After five years building similar systems, I know what it takes to make those patterns hold up over time."

**High-Velocity Startup:**
> "I thrive in high-velocity environments and am eager to bring [their new technology] into my toolkit. [Company]'s commitment to [their value] aligns with my approach to engineering, and I am ready to help [their product/platform] [their goal]."

**Final sentence options:**
- "I would welcome the opportunity to discuss how I can contribute to [Company]'s [team/platform/growth]."
- "I am eager to bring this experience to [Company] and help [specific goal from JD]."

---

## Part 3: Domain-Specific Language Reference

Use these terms when they match the job description:

**FinTech/Payments:**
- payment orchestration, settlement flows, merchant services, financial compliance
- card network flows, payment rails, merchant onboarding, transaction processing
- money movement, reconciliation, financial data integrity

**Healthcare/MedTech:**
- clinical workflows, care delivery, patient safety, provider portals
- healthcare-grade reliability, PHI (Protected Health Information)
- telehealth, care coordination, clinical pathways, patient outcomes
- EHR/EMR integration, HL7/FHIR standards

**Senior/Staff Engineering:**
- architectural decisions, technical strategy, design docs, RFCs
- patterns that hold up over time, patterns the next engineer reaches for
- technical trade-offs, incident response, engineering standards
- cross-functional collaboration, technical vision, long-term thinking

**Backend Engineering:**
- API design, database optimization, system reliability, performance tuning
- circuit breakers, failover routing, idempotency patterns
- microservices, service-oriented architecture, data modeling

**Full-Stack Engineering:**
- end-to-end ownership, vertical slices, type safety across the stack
- monorepo architecture, schema to UI, full-stack feature delivery

---

## Part 4: LaTeX Syntax Requirements

**IMPORTANT:** Follow LaTeX escaping rules from `.claude/skills/latex.md`:

- **Escape dollar signs**: `\$1B+` not `$1B+`
- **Use math mode for approximation**: `$\sim$250` for "~250"
- **Use math mode for comparison**: `$<$0.5\%` for "<0.5%"
- **Escape percentages**: `95\%` not `95%`
- **Use regular hyphens**: `-` not Unicode `‑` (U+2011)
- **Use en-dash for ranges**: `2021--2026` not `2021-2026`

**Reference**: See `.claude/skills/latex.md` for complete character escaping guide.

---

## Part 5: Quality Checklist

Before finalizing, ensure the cover letter:

- [ ] Uses exact role title from JD
- [ ] Uses REAL company names from resume variant (not placeholders)
- [ ] Mentions their company's mission/product specifically (not generic)
- [ ] Includes 4-6 relevant metrics (not all metrics!)
- [ ] Matches their technology stack terminology
- [ ] Uses their exact language/phrases from JD
- [ ] Addresses their key responsibilities
- [ ] Shows understanding of their domain
- [ ] Appropriate tone for company culture
- [ ] 3 paragraphs body text (~250-300 words)
- [ ] No generic phrases ("I am passionate about...")
- [ ] No typos or grammar errors
- [ ] LaTeX escaping correct (dollar signs, percentages, etc.)
- [ ] Ends with appropriate closing sentence
- [ ] Sounds like it was written FOR THIS ROLE, not adapted from a template

---

## Part 6: Example Case Studies

**These are reference examples showing how to analyze a JD and generate tailored prose. Do NOT copy these verbatim - use them as phrasing pattern guides.**

### Case Study 1: Full-Stack FinTech Role

**Hypothetical Job Description Summary:**
- Role: Senior Full Stack Engineer
- Company: Payment infrastructure startup
- Stack: TypeScript, Node.js, React/Angular
- Focus: Merchant-facing payment platform, compliance, reliability
- Culture: Technical craft, high ownership

**Analysis:**
- Emphasize: Payment gateway integration, PCI compliance, full-stack ownership
- Tech match: TypeScript, Node.js, Angular
- Metrics: $1B+ volume, 1.5M+ transactions, 99.95% uptime, 1,000+ users
- Tone: Technical craft + financial rigor

**Generated Cover Letter:**

```
I am applying for the Senior Full Stack Engineer role at [Company Name]. Building payment
infrastructure that merchants depend on requires end-to-end ownership—from gateway
integrations and fraud detection through admin dashboards and real-time transaction
monitoring—and I have spent the past five years doing exactly that. I led full-stack
development at [Current Company] using TypeScript, Angular, Node.js, and MongoDB,
scaling payment flows to process \$1B+ annually across 2,000+ locations while maintaining
PCI DSS Level 1 compliance and 99.95\% uptime.

At [Current Company], I integrated Braintree as our primary payment gateway and built
full-stack systems supporting 1.5M+ monthly transactions with strict financial compliance
requirements. I designed RESTful APIs with OpenAPI contracts and Zod validation, built a
multi-tenant admin portal with role-based access controls serving 1,000+ users, and
integrated fraud detection (Kount 360 via OAuth 2.0) that reduced chargebacks by 34\%. I
implemented 3DS authentication flows, Apple Pay/Google Pay tokenization, and real-time
WebSocket notifications using Socket.io to keep merchants informed during critical payment
workflows. I maintained 99.95\% uptime through circuit breakers, retries, and failover
routing, ensuring financial transaction integrity through idempotency patterns and
reconciliation workflows.

At [Previous Company], I owned backend architecture as sole developer alongside the CTO,
processing 500K+ monthly orders. I integrated multiple payment gateways (Auth.net, PayEezy,
PayPal), maintained PCI DSS compliance through regular security audits and vulnerability
scans, and built integration tooling that reduced partner onboarding by 85\% (3-4 weeks to
3-5 days). I migrated the platform to AWS achieving 99.98\% uptime and mentored eight
engineers, cutting onboarding time from 6 weeks to 2 weeks.

I have built financial systems where accuracy, compliance, and reliability are
non-negotiable—processing \$1B+ annually while maintaining PCI DSS Level 1 compliance. [Company
Name]'s payment platform requires that same rigor and full-stack ownership, and I am ready
to bring 17 years of payment systems expertise to your infrastructure.
```

**Why this works:**
- Opens with direct connection: payment infrastructure ownership
- Uses real company names extracted from user's resume variant
- Selects most relevant achievements (payment gateways, compliance, full-stack)
- Matches their stack (TypeScript, Node.js, Angular)
- Uses financial/payment language they'll recognize
- Closing reinforces rigor + full-stack ownership

---

### Case Study 2: HealthTech Full-Stack Role

**Hypothetical Job Description Summary:**
- Role: Staff Fullstack Engineer
- Company: Telehealth platform for preventative care
- Stack: Python, TypeScript, React
- Focus: Clinical workflows, compliance, patient data, integration complexity
- Culture: Mission-driven, impact-focused, fast-paced

**Analysis:**
- Emphasize: PCI → HIPAA compliance parallel, multi-tenant RBAC, integration complexity
- Tech match: TypeScript, React, full-stack
- Metrics: 99.95% uptime, 1,000+ users, integration experience
- Tone: Mission-driven + compliance rigor

**Generated Cover Letter:**

```
I am applying for the Staff Fullstack Engineer role at [Company]. Building the systems
that power telehealth workflows—from patient intake and eligibility through prescribing,
care plans, and follow-ups—requires the same end-to-end ownership and integration complexity
I have navigated throughout my career. I have spent the past five years building fullstack
systems at scale, integrating payment processors, fraud detection platforms, and fulfillment
systems while maintaining strict compliance requirements, and I am ready to apply that
experience to the clinical pathways that are transforming preventative care.

At [Current Company], I built and scaled fullstack systems using TypeScript, Node.js,
Angular, and MongoDB, growing payment flows from approximately 250 to 2,000+ locations
and monthly transactions from approximately 100K to over 1.5M while maintaining PCI DSS
Level 1 compliance—the same rigor required for HIPAA and patient data security. I designed
RESTful APIs with OpenAPI contracts and Zod schema validation for end-to-end type safety,
built a multi-tenant admin portal with role-based access controls serving 1,000+ users
(reducing unauthorized access by 95\%), and integrated third-party systems including WorldPay,
Clover, and Kount fraud detection via OAuth 2.0. I maintained 99.95\% uptime on critical
payment flows through circuit breakers, retries, and failover routing, and implemented
real-time WebSocket notifications using Socket.io to keep users informed during sensitive
workflows.

At [Previous Company], I owned architecture end-to-end, migrating a legacy platform to AWS while
building Node.js REST APIs and normalized SQL Server schemas that processed 500K+ monthly
orders. I integrated multiple payment gateways, maintained PCI DSS compliance through
regular vulnerability scans and security audits, and built integration tooling that reduced
third-party partner onboarding from weeks to days. I also mentored eight junior engineers
over an 11-year tenure, establishing code review practices and Git workflows that reduced
defects by 45\% and cut onboarding time from six weeks to two weeks.

Throughout my career, I have built systems where performance, reliability, and security are
not optional—whether processing \$1B+ in annual payments, maintaining PCI compliance, or
ensuring 99.95\% uptime on flows that users depend on in real time. [Company]'s mission to
make nutrition a foundational pillar of preventative care requires that same rigor, and I
am eager to bring that ownership and compliance-driven engineering experience to your
platform as you scale.
```

**Why this works:**
- Opens connecting telehealth workflows to integration complexity
- Uses real company names extracted from user's resume variant
- Draws PCI → HIPAA compliance parallel explicitly
- Emphasizes multi-tenant RBAC (maps to provider/patient portals)
- Reframes payment uptime as "systems users depend on" (patient safety)
- Closing ties to their mission directly

---

### Case Study 3: Technical/Craft-Driven Startup

**Hypothetical Job Description Summary:**
- Role: Senior Full Stack Engineer
- Company: Early-stage SaaS platform rebuilding from scratch
- Stack: TypeScript, Node.js, React
- Focus: Clean architecture, type safety, patterns that scale, mid-rebuild opportunity
- Culture: Engineering craft, technical excellence, best practices

**Analysis:**
- Emphasize: TypeScript monorepo, end-to-end type safety, architectural patterns
- Tech match: TypeScript, Node.js, React/Angular
- Metrics: Monorepo scale, engineering standards impact
- Tone: Technical craft + architecture + "patterns that hold up"

**Generated Cover Letter:**

```
I am applying for the Senior Full Stack Engineer role at [Company]. I have spent the past
five years building and scaling a TypeScript monorepo at [Current Company]—
shipping vertical slices from Mongoose schema to Express API to Angular component with
end-to-end type safety holding each feature together. The opportunity to join mid-rebuild
and set architectural patterns for a clean-room TypeScript platform is exactly the kind of
foundational work I am looking for.

At [Current Company], I led development of a TypeScript monorepo spanning Angular
frontend, Node.js/Express backend, and Mongoose/MongoDB data layer, scaling payment flows
from approximately 250 to 2,000+ locations and monthly transactions from approximately
100K to over 1.5M. I enforced end-to-end type safety using OpenAPI contracts, Zod schema
validation, and strict TypeScript configs—untyped boundaries and logic leaking into
controllers bothered me then as much as they would at [Company] now. I built a multi-tenant
admin portal with role-based access controls, designed permission-aware query layers, and
shipped database schema changes, API endpoints, and typed frontend forms in single PRs.
Over the past year, I adopted Claude Code, Cursor, and GitHub Copilot as force multipliers,
accelerating feature delivery by 3x to 5x while maintaining strict type boundaries and
engineering hygiene.

Earlier at [Previous Company], I led a clean-room rebuild migrating a legacy platform to AWS,
designing Node.js REST APIs and normalized SQL Server schemas from scratch while the old
system processed 500K+ monthly orders. I owned architecture end-to-end as the sole full-stack
developer alongside the CTO, integrated payment gateways and fulfillment systems, and built
integration tooling that reduced partner onboarding from weeks to days. In my final year,
we transitioned the backend to TypeScript, establishing the patterns and migration strategy
for a monorepo architecture.

The patterns I set in a TypeScript monorepo—how schemas flow through validators, how modules
enforce narrow boundaries, how migrations preserve type safety—become the patterns the next
engineer reaches for. [Company]'s clean-room rebuild is the most consequential moment to join,
and after five years in a similar stack, I know exactly what it takes to make those patterns
hold up over time.
```

**Why this works:**
- Opens with monorepo + vertical slices (matches their language)
- Uses real company names extracted from user's resume variant
- Emphasizes type safety obsessively (signals craft mindset)
- "untyped boundaries bothered me" shows attention to detail
- References AI tools (force multipliers for velocity)
- Closing uses their phrase "patterns that hold up" back to them
- Signals "mid-rebuild" opportunity understanding

---

## Final Reminders

1. **Read the job description carefully** - Don't skim, analyze deeply
2. **Extract real company names from resume variant** - Never use placeholders
3. **Select 4-6 most relevant achievements** - Not all achievements
4. **Write fresh prose tailored to THIS role** - Don't copy examples verbatim
5. **Match their language from the JD** - Use exact terms they use
6. **Use examples as pattern guides** - Learn phrasing styles, don't template
7. **Show understanding of their product/mission** - Generic = bad
8. **Proofread** - No typos, consistent formatting, LaTeX escaping correct
