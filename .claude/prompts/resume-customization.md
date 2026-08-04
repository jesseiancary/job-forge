# Resume Customization Guidelines

Use these guidelines to tailor existing resume variants for specific job applications.

**Important**: Resumes are **copied and tailored** from existing variants in `resumes/{variant}/`, NOT generated from scratch. All modifications preserve factual accuracy while adjusting emphasis, ordering, and technology mentions to match the target role.

## Overview

Resume customization focuses on:
1. **Reordering** bullet points to emphasize relevant experience
2. **Adjusting** the Professional Summary to match role focus
3. **Highlighting** matching technologies and skills
4. **Emphasizing** relevant metrics and outcomes
5. **Maintaining** factual accuracy across all changes

## LaTeX Syntax Requirements

**IMPORTANT**: Follow LaTeX escaping rules from `.claude/skills/latex.md`:

- **Escape dollar signs**: `\$1B+` not `$1B+`
- **Use math mode for approximation**: `$\sim$250` for "~250"
- **Use math mode for comparison**: `$<$0.5\%` for "<0.5%"
- **Escape percentages**: `95\%` not `95%`
- **Use regular hyphens**: `-` not Unicode `‑` (U+2011)
- **Use en-dash for ranges**: `2021--2026` not `2021-2026`

**Reference**: See `.claude/skills/latex.md` for complete character escaping guide.

## Customization Process

### Step 1: Analyze the Job Description

Extract and document:

1. **Role type** - Full-Stack, Backend, Frontend, Senior/Staff, etc.
2. **Key technologies** - Required and preferred tech stack
3. **Primary responsibilities** - What they need someone to do
4. **Domain** - Healthcare, payments, SaaS, infrastructure, etc.
5. **Company stage** - Startup, scale-up, established
6. **Team culture** - Mission-driven, technical/craft-focused, high-velocity
7. **Required experience** - Years, specific skills, leadership
8. **Scale/impact** - How large is their system/userbase

### Step 2: Select Sections to Modify

Common sections for tailoring:
- **Professional Summary** (always customize)
- **Current Role Experience** bullet ordering (usually customize)
- **Previous Role Experience** bullet ordering (sometimes customize)
- **Skills section** technology ordering (optional)

**Do NOT modify**:
- Contact information (uses `\input{../../config/personal-info}`)
- Metrics or facts (keep consistent)
- Education section
- Timeline/dates

### Step 3: Customize Professional Summary

**IMPORTANT: Generate from scratch** - Do NOT use a formula as a template. Analyze the user's experience from the resume variant and the job requirements, then write a fresh Professional Summary tailored to THIS specific role.

#### Generation Process

**Follow these steps:**

1. **Read the selected resume variant** to understand user's actual experience
   - What technologies have they used?
   - What are their most impactful achievements?
   - What metrics demonstrate their effectiveness?
   - How many years of experience do they have?

2. **Analyze the job description**
   - What role type is this? (Senior/Staff, Backend, Full-Stack, etc.)
   - What tech stack do they emphasize?
   - What scale/domain do they operate in?
   - What qualities are they looking for?

3. **Select 2-3 most relevant strengths** from user's background that match JD requirements

4. **Choose matching technologies** from their stack that align with JD

5. **Pick 2-3 key metrics** that align with the role's scale/domain

6. **Write fresh prose** that synthesizes their experience toward this specific role

**Target Length**: 3-4 sentences (60-80 words max)

---

#### Professional Summary Structure

**Sentence 1**: [Role title] + [years] + [type of systems] + [matching tech stack]

**Sentence 2**: [Key strength 1 with metric] + [key strength 2 with metric]

**Sentence 3**: [Leadership/collaboration for Senior+] OR [infrastructure/deployment for IC roles]

**Sentence 4** (Optional): [AI tools for velocity if relevant to role culture]

**Guidelines**:
- Lead with role title that matches JD (e.g., "Full-stack engineer", "Backend engineer", "Senior software engineer")
- Match their tech stack terminology exactly
- Choose metrics that align with their scale/domain
- Avoid redundancy - each sentence adds new information
- Be specific but concise

---

#### Emphasis Patterns by Role Type

**Use these as guides for WHAT to emphasize, not WHAT to say.** Synthesize these elements into your own sentences based on the user's actual experience.

**For Senior/Staff/Lead Roles:**
- **EMPHASIZE**: Architectural decisions, technical leadership, cross-functional collaboration
- **INCLUDE**: System design at scale metrics (X→Y growth, uptime, user count)
- **INCLUDE**: Team impact (mentored X engineers, reduced defects/onboarding time)
- **LANGUAGE**: "led", "established", "defined patterns", "partnered with executives"
- **METRICS TO CHOOSE**: Scaling numbers, team metrics, engineering standards impact

**For Payment/FinTech Roles:**
- **EMPHASIZE**: Payment gateways (name specific ones), financial compliance, transaction volume
- **INCLUDE**: PCI DSS compliance, fraud detection, uptime on payment-critical flows
- **INCLUDE**: Integration experience (partner onboarding metrics)
- **LANGUAGE**: "payment systems", "financial transaction processing", "merchant services"
- **METRICS TO CHOOSE**: Transaction volume ($X+ annual, Y+ monthly), compliance, fraud reduction

**For Healthcare/MedTech Roles:**
- **EMPHASIZE**: Compliance (PCI→HIPAA parallel), secure systems, sensitive data handling
- **INCLUDE**: Multi-tenant with RBAC, access control metrics
- **INCLUDE**: High uptime on systems users depend on (patient safety parallel)
- **LANGUAGE**: "secure, compliant systems", "healthcare-grade reliability", "patient safety"
- **METRICS TO CHOOSE**: Compliance rigor, access control effectiveness, uptime

**For Backend Roles:**
- **EMPHASIZE**: API design, database optimization, system reliability
- **INCLUDE**: Performance metrics (uptime, response times, load reduction)
- **INCLUDE**: Infrastructure experience (cloud, containers, CI/CD)
- **LANGUAGE**: "high-performance APIs", "scalable systems", "database optimization"
- **METRICS TO CHOOSE**: Uptime %, performance improvements, scaling capacity

**For Full-Stack Roles:**
- **EMPHASIZE**: End-to-end ownership, full-stack tech stack (frontend + backend)
- **INCLUDE**: Type safety, multi-tenant systems, real-time features
- **INCLUDE**: AI tools for velocity (if startup/high-velocity culture)
- **LANGUAGE**: "full-stack", "end-to-end", "vertical slices", "schema to UI"
- **METRICS TO CHOOSE**: Scaling metrics, velocity improvements, system scope

**For Startup Roles:**
- **EMPHASIZE**: Early-stage ownership, working directly with founders/CTO/CEO
- **INCLUDE**: Scaling metrics (X→Y growth in users/revenue/locations)
- **INCLUDE**: Wearing multiple hats, fast-paced environment
- **LANGUAGE**: "startup experience", "sole developer", "alongside CTO/CEO"
- **METRICS TO CHOOSE**: Scaling numbers, velocity metrics, breadth of ownership

---

#### Example: How to Generate a Professional Summary

**Scenario**: User applying for Senior Backend Engineer at a FinTech startup

**Step 1: Analyze user's resume variant**
```
Experience summary from resume:
- 15 years total experience
- Most recent role: Payment platform company (5 years)
  - Tech: Node.js, TypeScript, PostgreSQL, Redis
  - Achievements: Scaled to 500K users, 99.9% uptime, integrated 3 payment gateways
  - Metrics: Processing $100M annually
- Previous role: E-commerce platform (10 years)
  - Tech: Node.js, Express, MySQL
  - Leadership: Mentored 5 engineers, reduced onboarding time 50%
```

**Step 2: Analyze job description**
```
Job requirements:
- Role: Senior Backend Engineer
- Domain: FinTech/payments
- Stack: Node.js, TypeScript, PostgreSQL (EXACT MATCH!)
- Responsibilities: API design, payment integrations, scaling infrastructure, mentorship
- Culture: Startup, high ownership, fast-paced
```

**Step 3: Select elements to emphasize**
```
Match analysis:
- Years: 15 years ✓
- Role type: Backend (match JD "Backend Engineer")
- Tech: Node.js, TypeScript, PostgreSQL (100% match!)
- Domain: Payment systems (perfect for FinTech role)
- Strengths: Scaling, uptime, payment gateway integrations
- Metrics: 500K users, 99.9% uptime, $100M volume, 3 gateways
- Leadership: Mentored 5 engineers (relevant for "Senior" level)
```

**Step 4: Generate fresh Professional Summary**
```latex
Backend software engineer with 15 years of experience building payment systems using Node.js,
TypeScript, and PostgreSQL. Integrated three payment gateways and scaled platform to 500K users
processing \$100M annually while maintaining 99.9\% uptime on financial transaction flows.
Mentored five engineers and established API design standards that reduced integration time by 50\%.
```

**Why this works:**
- Leads with "Backend software engineer" (matches role title exactly)
- Tech stack (Node.js, TypeScript, PostgreSQL) matches JD requirements 100%
- Metrics align with startup scale (500K users, $100M is realistic for scaling startup)
- Includes payment domain expertise (3 gateways, financial transactions)
- Shows leadership appropriate for Senior level (mentored, established standards)
- Fresh prose synthesized from user's actual experience, not templated

### Step 4: Reorder Experience Bullets

Reorder bullets within each role to put the most relevant first. **Do NOT change the content of bullets**—only their order.

#### Payment Platform Company (Current Role)

**For Full-Stack Roles** - Prioritize:
1. TypeScript monorepo architecture
2. Multi-tenant admin portal with RBAC
3. Real-time WebSocket notifications
4. End-to-end type safety (OpenAPI, Zod)
5. Payment gateway integrations
6. Performance improvements
7. Fraud detection

**For Backend Roles** - Prioritize:
1. RESTful APIs with OpenAPI contracts
2. Database optimization (60% load reduction)
3. System reliability (circuit breakers, failover)
4. Payment gateway integrations
5. Performance improvements (45% faster APIs)
6. Redis caching
7. Real-time WebSocket notifications

**For Healthcare Roles** - Prioritize:
1. PCI DSS Level 1 compliance
2. Multi-tenant with RBAC (95% unauthorized access reduction)
3. Integration with third-party systems (OAuth 2.0)
4. End-to-end type safety and validation
5. System reliability (99.95% uptime)
6. Audit trails and monitoring
7. Real-time notifications

**For Payment/FinTech Roles** - Prioritize:
1. Payment gateway integrations (Braintree, WorldPay, Clover)
2. PCI DSS Level 1 compliance
3. Fraud detection (Kount 360, 34% reduction)
4. Transaction scale ($1B+, 1.5M+ monthly)
5. System reliability (99.95% uptime)
6. 3DS authentication, Apple Pay/Google Pay
7. Circuit breakers and failover routing

**For Startup Roles** - Prioritize:
1. Scaling metrics (250 → 2,000+ locations, 100K → 1.5M+ transactions)
2. Working directly with CTO and CEO
3. End-to-end ownership (schema → API → UI)
4. AI tools for velocity (3x-5x improvement)
5. Multi-tenant admin portal
6. Payment integrations
7. Performance optimizations

**For Senior/Staff Roles** - Prioritize:
1. Architectural decisions (TypeScript monorepo, design patterns)
2. Cross-functional collaboration (CEO, product stakeholders, executives)
3. Scaling metrics (250 → 2,000+ locations, 100K → 1.5M+ transactions)
4. System design trade-offs (reliability vs velocity, technical debt management)
5. Engineering standards & mentorship (code reviews, onboarding improvements)
6. Multi-tenant admin with RBAC (1,000+ users, 95% unauthorized access reduction)
7. System reliability & incident ownership (99.95% uptime, SLA management)
8. Long-term technical vision (patterns that hold up over time)

**For FinTech Roles** - Prioritize:
1. Payment gateway integrations (Braintree, WorldPay, Clover - name specific ones)
2. Financial transaction volume ($1B+ annual, 1.5M+ monthly transactions)
3. PCI DSS Level 1 compliance
4. Fraud detection (Kount 360, 34% reduction)
5. System reliability (99.95% uptime on payment-critical flows)
6. 3DS authentication, tokenization (Apple Pay/Google Pay)
7. Circuit breakers, retries, failover for money movement
8. Partner/merchant integration tooling (85% faster onboarding)

**For HealthTech Roles** - Prioritize:
1. PCI DSS Level 1 compliance (healthcare-grade compliance rigor)
2. Multi-tenant RBAC (1,000+ users, 95% unauthorized access reduction)
3. Integration with third-party systems (OAuth 2.0, REST APIs)
4. 99.95% uptime (systems users depend on in real time = patient safety)
5. Audit trails and security monitoring
6. Real-time WebSocket notifications (clinical alerts parallel)
7. End-to-end type safety and data validation
8. Multi-location system management (2,000+ sites)

#### E-commerce Platform Company (Earlier Role)

**For Full-Stack Roles** - Prioritize:
1. Owned architecture end-to-end (sole developer with CTO)
2. AWS migration
3. Node.js REST APIs + SQL Server schemas
4. Mentorship (8+ engineers)
5. Payment gateway integrations
6. Fulfillment center tooling

**For Backend-Only Roles** - Prioritize:
1. Node.js REST API architecture
2. SQL Server schema design and optimization
3. AWS infrastructure (EC2, RDS, S3, Route53)
4. Payment gateway integrations (Auth.net, PayEezy, PayPal)
5. PCI DSS compliance
6. Integration tooling (85% time reduction)

**For Senior/Staff Roles** - Prioritize:
1. 11-year tenure, sole developer with CTO
2. Mentorship (8+ engineers, 45% defect reduction)
3. Code quality culture (code reviews, Git workflows)
4. Owned architecture end-to-end
5. Cross-functional collaboration
6. Long-term system ownership

#### Mining Software Company (Earlier Role)

**Use When**:
- Role emphasizes React experience
- Role requires C#/.NET or SQL Server familiarity
- Need to show breadth across different stacks

**De-emphasize When**:
- Backend-only roles (mention briefly or skip)
- Startup roles (enterprise environment less relevant)

### Step 5: Adjust Skills Section (Optional)

If the resume variant includes a Skills section, reorder technologies to put the most relevant first.

**Example for React + Node.js Role**:
```
Languages & Frameworks: React, TypeScript, Node.js, Express, Angular, JavaScript, HTML5, CSS3
```

**Example for Angular + Backend Role**:
```
Languages & Frameworks: Angular, TypeScript, Node.js, Express, JavaScript, HTML5, CSS3
```

**Example for Backend-Heavy Role**:
```
Languages & Frameworks: Node.js, Express, TypeScript, JavaScript, MongoDB, SQL Server, T-SQL
```

### Step 6: Add Role-Specific Technology Mentions

If the job description emphasizes specific technologies you've used but aren't prominently mentioned, consider adding them to relevant bullets (if factually accurate).

**Example**: If role emphasizes Redis and you've used it but it's not mentioned:
```latex
% Before:
Implemented caching strategies that reduced database load by 60\%

% After (if Redis was actually used):
Implemented Redis caching strategies that reduced database load by 60\%
```

**IMPORTANT**: Only add technology names if you actually used them. Never claim tools you haven't used.

## Role-Specific Customization Patterns

### Full-Stack Engineer

**Emphasize**:
- End-to-end ownership (schema → API → UI)
- TypeScript monorepo with end-to-end type safety
- Both frontend (Angular/React) and backend (Node.js/Express)
- Multi-tenant systems with RBAC
- Real-time features (WebSockets, Socket.io)
- Performance optimization across the stack

**Professional Summary Focus**: End-to-end type safety, multi-tenant systems, full ownership

**Bullet Ordering**: TypeScript monorepo → multi-tenant admin → real-time features → integrations

### Backend Engineer

**Emphasize**:
- API design (REST, OpenAPI, Zod validation)
- Database architecture and optimization
- System reliability (uptime, circuit breakers, failover)
- Performance tuning (caching, query optimization)
- Third-party integrations
- Infrastructure (AWS, Docker, Kubernetes)

**Professional Summary Focus**: High-performance APIs, database optimization, system reliability

**Bullet Ordering**: API design → database optimization → reliability patterns → integrations

**De-emphasize**: Frontend frameworks, UI/UX work

### Healthcare / MedTech

**Emphasize**:
- Compliance (PCI DSS → HIPAA parallels)
- Security (RBAC, OWASP Top 10, audit trails)
- Sensitive data handling
- Integration complexity (payment gateways → EHR/pharmacy)
- Multi-tenant with strict access controls
- 99.95%+ uptime on critical systems

**Professional Summary Focus**: Compliance, security, sensitive data, reliability

**Bullet Ordering**: PCI compliance → multi-tenant RBAC → integrations → reliability

**Language to Add**: "sensitive data", "strict access controls", "audit trails", "compliance"

### Payment / FinTech

**Emphasize**:
- Payment gateway integrations (name specific ones)
- PCI DSS Level 1 compliance
- Fraud detection (Kount 360, OAuth 2.0)
- Transaction volume ($1B+, 1.5M+ monthly)
- 99.95% uptime requirements
- 3DS authentication, tokenization (Apple Pay, Google Pay)

**Professional Summary Focus**: Payment systems, PCI compliance, transaction scale

**Bullet Ordering**: Payment integrations → PCI compliance → fraud detection → scale metrics

**Language to Add**: "payment flows", "transaction processing", "merchant services", "financial data"

### Startup / Early-Stage

**Emphasize**:
- Scaling metrics (250 → 2,000+, 100K → 1.5M+)
- Working directly with founders/CTO/CEO
- End-to-end ownership
- Wearing multiple hats
- AI tools for velocity (3x-5x)
- Early-stage context (11 years at e-commerce startup)

**Professional Summary Focus**: Startup experience, end-to-end ownership, velocity

**Bullet Ordering**: Scaling metrics → working with executives → AI velocity → end-to-end ownership

**De-emphasize**: Enterprise processes, large teams

### Senior / Staff / Lead Engineer

**Emphasize**:
- Mentorship (8+ engineers mentored)
- Architectural decisions
- Code quality and engineering culture
- Cross-functional collaboration (product, design, executives)
- Long tenure (5 years at payment platform, 11 years at e-commerce company)
- Establishing team practices

**Professional Summary Focus**: Leadership, architecture, mentorship, long-term impact

**Bullet Ordering**: Architecture → collaboration → mentorship → scaling → code quality

**Language to Add**: "led", "established", "partnered with", "mentored", "championed"

## Quality Checklist

Before finalizing the tailored resume, ensure:

- [ ] Professional Summary matches role type and tech stack
- [ ] Current role bullets are reordered for relevance
- [ ] Most relevant experience is in the top 3-4 bullets
- [ ] Matching technologies are mentioned prominently
- [ ] Metrics are accurate and consistent with CLAUDE.md
- [ ] No technology claims you haven't actually used
- [ ] Contact info uses `\input{../../config/personal-info}`
- [ ] Education description remains generic (Computer Science)
- [ ] No typos or grammar errors
- [ ] Regular hyphens (-) not non-breaking hyphens (‑)
- [ ] Dollar signs properly escaped (\$1B+ not $1B+)
- [ ] Approximations use math mode ($\sim$250 not ~250)
- [ ] Percentages escaped (95\% not 95%)
- [ ] Factual accuracy maintained across all changes
- [ ] File compiles with XeLaTeX without errors

## Common Mistakes to Avoid

1. **Don't change bullet point content** - Only reorder for emphasis
2. **Don't inflate metrics** - Keep numbers consistent with CLAUDE.md
3. **Don't add technologies you haven't used** - Be honest about experience
4. **Don't make Professional Summary too generic** - Tailor to role type
5. **Don't modify contact information** - Uses `\input{}` command
6. **Don't forget to match their language** - Use exact phrases from JD
7. **Don't ignore company culture** - Adjust tone appropriately
8. **Don't skip proofreading** - Check for LaTeX compilation errors

## Metrics Reference (Keep Consistent)

Use these metrics consistently across all resume variants:

**Current Role Scale**:
- 250 → 2,000+ locations
- 100K → 1.5M+ monthly transactions
- $1B+ annual payment volume

**Current Role Performance**:
- 99.95% payment API uptime
- 60% database load reduction
- 45% API response time improvement
- 55% customer wait time reduction

**Current Role Security**:
- 1,000+ admin users onboarded
- 95% reduction in unauthorized access
- 34% fraud reduction (Kount 360)
- PCI DSS Level 1 compliance

**E-commerce Platform**:
- 500K+ monthly orders
- 11-year tenure
- 8+ engineers mentored
- 45% defect reduction through code reviews
- 85% integration time reduction (3-4 weeks → 3-5 days)
- 6 weeks → 2 weeks onboarding time
- 99.98% uptime (AWS migration)
- 35% cost reduction (AWS migration)

**Mining Software Company**:
- 30% planning time reduction

**AI Tools**:
- 3x-5x feature delivery velocity improvement

## Example Customization Workflow

**Scenario**: Applying for Senior Backend Engineer role at a FinTech startup

**Step 1 - Analysis**:
- Role type: Backend, Senior
- Tech: Node.js, TypeScript, PostgreSQL, Redis
- Domain: FinTech, payment processing
- Stage: Early-stage startup

**Step 2 - Professional Summary**:
Updated to emphasize backend, payments, startup experience, leadership

**Step 3 - Current Role Bullet Ordering**:
1. Payment gateway integrations (Braintree, WorldPay, Clover)
2. RESTful APIs with OpenAPI contracts
3. Database optimization (60% load reduction)
4. PCI DSS Level 1 compliance
5. Fraud detection (Kount 360)
6. System reliability (99.95% uptime, circuit breakers)
7. Performance improvements (45% faster APIs)

**Step 4 - E-commerce Platform Bullet Ordering**:
1. Node.js REST API architecture
2. Payment gateway integrations (Auth.net, PayEezy, PayPal)
3. AWS infrastructure
4. Mentorship (8+ engineers)
5. Integration tooling (85% time reduction)

**Step 5 - Review**:
- Matches: Node.js ✓, TypeScript ✓, Payment experience ✓, Startup experience ✓
- Emphasizes: Backend architecture, API design, payments, scaling, leadership
- De-emphasizes: Frontend frameworks, UI work

## Final Notes

- **Always start with the appropriate variant** - Let the user select which base resume to use
- **Preserve factual accuracy** - Never change what you actually did
- **Reorder, don't rewrite** - Bullet points should remain truthful
- **Match their language** - Use exact terms from the job description
- **Keep metrics consistent** - Reference CLAUDE.md for approved numbers
- **Tailor the summary heavily** - This is where you match the role most directly
- **Get user approval** - Present changes before applying them
- **Compile to verify** - Make sure LaTeX file builds correctly
