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

The Professional Summary is the most important section to tailor. Adjust emphasis based on role type.

#### Formula for Professional Summary

**Target Length**: 3-4 sentences (60-80 words max)

```
[Job title] with [X years] of experience building [type of systems] using [matching tech stack].
[Key strength 1 with metric], [key strength 2 with metric]. [Leadership/collaboration for Senior+,
OR deployment/infrastructure for IC roles]. [Optional: AI tools for velocity-focused roles].
```

**Guidelines**:
- Keep to 3-4 sentences maximum
- Lead with role + years + tech stack
- Include 2-3 key strengths with metrics
- Avoid redundancy - don't repeat the same concept twice
- Be specific but concise

#### Examples by Role Type (Prioritized by Target Industries)

**Senior/Staff/Lead Roles** (Primary Target):
```latex
Senior software engineer with 17 years of experience leading architectural decisions and building
high-scale systems using TypeScript, Node.js, Angular, and SQL/NoSQL databases. Scaled systems from
250 to 2,000+ locations and 100K to 1.5M+ monthly transactions while maintaining 99.95% uptime on
payment flows processing $1B+ annually. Established engineering standards that reduced defects by
45% and mentored 8+ engineers, cutting onboarding time from 6 weeks to 2 weeks.
```

**Payment/FinTech Roles** (Primary Target):
```latex
Backend software engineer with 17 years of experience building payment systems using Node.js,
TypeScript, and MongoDB. Integrated payment gateways (Braintree, WorldPay, Clover) and maintained
PCI DSS Level 1 compliance while processing $1B+ annually across 1.5M+ monthly transactions at
99.95% uptime. Reduced fraud by 34% with Kount 360, optimized database performance by 60%, and
accelerated partner onboarding by 85%.
```

**Healthcare/MedTech Roles** (Primary Target):
```latex
Full-stack software engineer with 17 years of experience building secure, compliant systems using
Angular, TypeScript, Node.js, and MongoDB. Maintained PCI DSS Level 1 compliance while processing
$1B+ in transaction volume—compliance rigor directly applicable to HIPAA requirements. Built
multi-tenant systems with role-based access controls serving 1,000+ users and achieved 99.95%
uptime on systems users depend on in real time.
```

**Backend Roles**:
```latex
Backend software engineer with 17 years of experience building high-performance APIs and scalable
systems using Node.js, Express, TypeScript, MongoDB, and SQL Server. Maintained 99.95% uptime
while processing $1B+ in annual transaction volume with optimized database queries, Redis caching,
and circuit breakers. Experienced with AWS infrastructure, PCI DSS Level 1 compliance, and
establishing code quality standards.
```

**Full-Stack Roles**:
```latex
Full-stack software engineer with 17 years of experience building scalable applications using
Angular, React, TypeScript, Node.js, and SQL/NoSQL databases. Built TypeScript monorepos with
end-to-end type safety, multi-tenant systems with role-based access controls, and real-time
features using WebSockets. Leveraged AI-assisted development tools (Claude Code, Cursor, GitHub
Copilot) to accelerate feature delivery by 3x to 5x.
```

**Startup Roles**:
```latex
Full-stack software engineer with 17 years of startup experience, including 11 years as sole
developer alongside the CTO at an e-commerce platform processing 500K+ monthly orders. Scaled
systems from 250 to 2,000+ locations while maintaining 99.95% uptime and PCI DSS compliance.
Leveraged AI-assisted development tools to accelerate feature delivery by 3x to 5x.
```

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
