# Job Search Materials

This repository contains LaTeX-based resumes and cover letters tailored for various software engineering positions.

## Project Structure

```
job-forge/
├── .claude/                                   # Claude Code configuration
│   ├── commands/
│   │   └── new.md                             # /new slash command for creating applications
│   ├── skills/
│   │   ├── job-application-helper.md          # Reusable context and guidelines
│   │   └── latex.md                           # LaTeX compilation instructions
│   └── prompts/
│   |   ├── resume-customization.md            # Resume tailoring guidelines
│   |   ├── cover-letter-generation.md         # Cover letter generation guidelines
│   |   └── fintech-healthtech-positioning.md  # Industry-specific positioning strategies
│   └── settings.json                          # Claude Code settings
├── config/                                    # Personal information (gitignored)
│   ├── personal-info.template.tex             # LaTeX config template (committed)
│   ├── personal-info.tex                      # Your LaTeX variables (gitignored - YOU CREATE THIS)
│   ├── PERSONAL_INFO.template.md              # Markdown template (committed)
│   └── PERSONAL_INFO.md                       # Your info for Claude (gitignored - YOU CREATE THIS)
├── applied/                                   # Company-specific application materials
│   └── {company-slug}/
│       ├── {company-slug}-resume.tex          # Resume tailored to the job description
│       └── {company-slug}-cover-letter.tex    # AI-generated cover letter tailored to the job description
├── resumes/                                   # Resume templates and variants
│   ├── sample/
│   │   ├── resume.tex                         # Sample resume template (committed, copy to create variants)
│   │   └── cover-letter.tex                   # Cover letter template with COMPANY_NAME and BODY_TEXT placeholders
│   ├── {resume-variant-1}/
│   │   └── resume.tex                         # A resume variant (gitignored - YOU CREATE THIS)
│   └── {resume-variant-2}/
│       └── resume.tex                         # A resume variant (gitignored - YOU CREATE THIS)
├── signature.png                              # Your signature image (gitignored - YOU CREATE THIS)
├── sample-signature.png                       # Sample signature fallback (committed)
└── CLAUDE.md                                  # This file
├── README.md                                  # This file
└── .gitignore                                 # Git ignore patterns
```

## Quick Start: Creating a New Application

Use the `/new` slash command to automatically create tailored application materials:

```
/new
```

This will:
1. Prompt you for the company name
2. Ask for the job description
3. Ask you to select which resume variant to use
4. Create a directory in `/applied/{company-slug}/`
5. Copy and tailor the resume (asks for your approval first)
6. Generate a custom cover letter (automatic, no approval needed)

### Example Workflow (FinTech Role)

```
You: /new

Claude: What is the company name?
You: Stripe

Claude: Please paste the full job description.
You: [paste Senior Backend Engineer - Payments JD]

Claude: Which resume variant would you like to use?
Available variants: senior-staff, fintech, healthtech, backend, full-stack

You: fintech

Claude: Creating directory: /applied/stripe/

I propose these tailoring changes to the resume:
- Update Professional Summary to emphasize payment systems and financial transaction processing
- Prioritize payment gateway integration bullets (Braintree, WorldPay, Clover)
- Move PCI DSS Level 1 compliance and $1B+ payment volume metrics higher
- Add fraud detection (Kount 360, 34% reduction) near the top
- Emphasize transaction integrity, idempotency, and reconciliation workflows
- Include money movement terminology (settlement, card network flows)

Should I proceed with these changes?

You: Yes

Claude: ✓ Created /applied/stripe/stripe-resume.tex (tailored FinTech resume)
✓ Created /applied/stripe/stripe-cover-letter.tex (generated cover letter)

To compile PDFs:
cd applied/stripe
xelatex stripe-resume.tex
xelatex stripe-cover-letter.tex

This generates:
- stripe-resume.pdf
- stripe-cover-letter.pdf
```

### Example Workflow (HealthTech Role)

```
You: /new

Claude: What is the company name?
You: Cedar

Claude: Please paste the full job description.
You: [paste Staff Engineer - Patient Platform JD]

Claude: Which resume variant would you like to use?
Available variants: senior-staff, fintech, healthtech, backend, full-stack

You: healthtech

Claude: Creating directory: /applied/cedar/

I propose these tailoring changes to the resume:
- Update Professional Summary to emphasize secure, compliant systems for sensitive data
- Prioritize PCI DSS Level 1 compliance (healthcare-grade compliance rigor)
- Move multi-tenant RBAC bullets higher (1,000+ users, 95% unauthorized access reduction)
- Emphasize 99.95% uptime as patient safety requirement
- Add EHR/EMR integration readiness language
- Frame payment data handling → PHI handling parallels
- Include clinical workflows and care delivery terminology

Should I proceed with these changes?

You: Yes

Claude: ✓ Created /applied/cedar/cedar-resume.tex (tailored HealthTech resume)
✓ Created /applied/cedar/cedar-cover-letter.tex (generated cover letter)

To compile PDFs:
cd applied/cedar
xelatex cedar-resume.tex
xelatex cedar-cover-letter.tex

This generates:
- cedar-resume.pdf
- cedar-cover-letter.pdf
```

## Resume Variants

Create resume variants tailored to your primary target industries:

### Senior/Staff Engineer Resume (Recommended)
**Focus**: Technical leadership, architectural decisions, cross-functional impact, mentorship, system design
**Use for**: Staff Engineer, Senior Engineer, Technical Lead roles (any domain)
**Emphasize**: 17 years experience, architectural ownership, team influence, design docs/RFCs, scaling impact
**Industries**: FinTech, HealthTech, SaaS, any senior-level roles

### FinTech/Payment Resume (Primary Target)
**Focus**: Payment systems, financial compliance, transaction processing, API design, system reliability
**Use for**: Payment Engineer, FinTech Backend/Full-Stack, Merchant Services, Financial Infrastructure roles
**Emphasize**: $1B+ payment volume, PCI DSS Level 1, payment gateways, fraud detection, 99.95% uptime
**Key angles**: Money movement, transaction integrity, merchant onboarding, financial compliance

### HealthTech Resume (Primary Target)
**Focus**: Compliance-driven systems, sensitive data handling, integration complexity, healthcare-grade reliability
**Use for**: HealthTech, MedTech, Telehealth, Clinical Platform, Provider Portal roles
**Emphasize**: PCI → HIPAA parallels, multi-tenant RBAC, 99.95% uptime = patient safety, EHR/EMR readiness
**Key angles**: Sensitive data (payment → PHI), clinical workflows, provider portals, audit trails

### Backend Resume
**Focus**: Node.js/Express backend, API design, database architecture, system reliability
**Use for**: Backend Engineer, Senior Backend Engineer roles (general)
**Emphasize**: RESTful APIs, database optimization, system reliability patterns

### Full-Stack Resume
**Focus**: End-to-end ownership, Angular/React frontend + Node.js backend, TypeScript monorepos
**Use for**: Full-Stack Engineer roles requiring both frontend and backend depth
**Emphasize**: Multi-tenant systems, end-to-end type safety, real-time features

## Applied Directory

The `/applied/` directory contains company-specific application materials created using the `/new` command or manually. Each subdirectory is named using lowercase-with-hyphens format:

**Existing applications**:
- `boulevard/` - Boulevard (client experience platform for salons/spas)
- `higharc/` - HighArc
- `parachute-health/` - Parachute Health
- `suite-op/` - Suite-Op (property operations platform)
- `sunbound/` - Sunbound (Revenue Operating System for senior living)
- `tilled/` - Tilled (Payfac-as-a-Service)
- `upstart/` - Upstart
- `weight-watchers/` - WeightWatchers (telehealth clinic platform)

**File naming pattern**:
- Resume: `{company-slug}-resume.tex` (when present)
- Cover letter: `{company-slug}-cover-letter.tex`
- Multiple variants: `{company-slug}-{variant}-cover-letter.tex` (e.g., `sunbound-backend-cover-letter.tex`, `sunbound-full-stack-cover-letter.tex`)

## Cover Letter Template

The base template at `resumes/sample/cover-letter.tex` uses `COMPANY_NAME` and `BODY_TEXT` placeholders that are replaced when generating applications.

## Compilation

All LaTeX files require **XeLaTeX** (for Calibri font support via fontspec):

```bash
xelatex resume.tex
xelatex cover-letter.tex
```

### Common Issues

**Font Warning**: `Missing character: There is no ‑ (U+2011) in font Calibri`
- **Solution**: Use regular hyphens (`-`) instead of non-breaking hyphens (`‑`)

**Signature Not Found**: Check that `signature.png` exists in project root

## Using the `/new` Command

The `/new` slash command automates the creation of tailored job application materials using context from:
- [.claude/skills/job-application-helper.md](.claude/skills/job-application-helper.md) - Experience summary, metrics, tech stack, and customization patterns
- [.claude/prompts/resume-customization.md](.claude/prompts/resume-customization.md) - Resume tailoring guidelines
- [.claude/prompts/cover-letter-generation.md](.claude/prompts/cover-letter-generation.md) - Cover letter generation guidelines

See the [Quick Start](#quick-start-creating-a-new-application) section above for the complete workflow.

## Personal Information Configuration System

This project uses a centralized configuration system for personal information (name, contact info, etc.):

### Setup (First Time)

1. **Copy the LaTeX template**:
   ```bash
   cp config/personal-info.template.tex config/personal-info.tex
   ```

2. **Edit `config/personal-info.tex`** with your information:
   ```latex
   \newcommand{\MyName}{Your Name}
   \newcommand{\MyTitle}{Your Current Position}
   \newcommand{\MyCity}{City}
   \newcommand{\MyState}{State}
   \newcommand{\MyPhone}{(987) 654-3210}
   \newcommand{\MyEmail}{your.email@gmail.com}
   \newcommand{\MyLinkedIn}{linkedin.com/in/your-profile}
   \newcommand{\MyGitHub}{github.com/your-profile}
   ```

3. **Copy the Markdown template** (for Claude Code):
   ```bash
   cp config/PERSONAL_INFO.template.md config/PERSONAL_INFO.md
   ```

4. **Edit `config/PERSONAL_INFO.md`** with the same information

5. **Add your signature**: Place `signature.png` in project root (optional - will use `sample-signature.png` as fallback)

### How It Works

- **LaTeX files** use `\input{../config/personal-info}` to import your variables
- **Claude Code** reads `config/PERSONAL_INFO.md` when generating applications
- **Git ignores** `config/personal-info.tex`, `config/PERSONAL_INFO.md`, and `signature.png`
- **Templates are committed** so others can set up their own versions

### Benefits

✓ **Single source of truth** - Update info once, applies everywhere
✓ **Privacy-safe** - Personal info never committed to git
✓ **Easy maintenance** - Change phone/email in one place
✓ **Type-safe** - LaTeX commands ensure consistent formatting

## Maintenance Notes

- **Signature**: Keep `signature.png` at project root (gitignored, falls back to `sample-signature.png` if missing)
- **Font**: Calibri required, or uncomment fallback font in LaTeX files
- **Metrics**: Update if experience changes (e.g., new role, updated scale numbers)
- **Contact Info**: Update in `config/personal-info.tex` and `config/PERSONAL_INFO.md`
