# Job Forge

**An AI-powered job application system for software engineers**

Job Forge is a LaTeX-based resume and cover letter management system integrated with Claude Code. It helps you create tailored application materials by selecting and tailoring your preferred resume variant and generating custom cover letters based on job descriptions.

## Quick Start for New Users

1. Complete [Prerequisites](#prerequisites) and [Installation](#installation)
2. Complete [Initial Setup](#initial-setup) (configure personal info)
3. **⭐ IMPORTANT**: Complete [First-Time Setup: Customizing for Your Experience](#first-time-setup-customizing-for-your-experience) (replace sample content with your background)
4. Start using `/new` to create applications - see [Usage](#usage)

---

## Table of Contents

1. [Features](#features)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Initial Setup](#initial-setup)
5. [First-Time Setup: Customizing for Your Experience](#first-time-setup-customizing-for-your-experience) ⭐ **Important for New Users**
6. [Usage](#usage)
7. [Project Structure](#project-structure)
8. [Customization Guide](#customization-guide)
9. [Troubleshooting](#troubleshooting)
10. [Tips & Best Practices](#tips--best-practices)

---

## Features

- **User-Selected Resume Variants**: Choose the best resume variant (full-stack, backend, etc.) for each application
- **AI-Powered Resume Customization**: Automatically tailors your selected resume based on job description analysis
- **Custom Cover Letter Generation**: Creates tailored cover letters matching company mission, tech stack, and role requirements
- **Multiple Resume Variants**: Maintain different versions optimized for different role types
- **LaTeX-Based**: Professional typesetting with XeLaTeX and Calibri font
- **Claude Code Integration**: Streamlined workflow using the `/new` slash command
- **Version Control Ready**: Track all changes to your application materials in Git

---

## Prerequisites

### Required Software

1. **VS Code** (or compatible editor)
   - Download: https://code.visualstudio.com/

2. **Claude Code Extension**
   - Install from VS Code Extensions Marketplace
   - Search for "Claude Code"
   - Requires Anthropic API key

3. **XeLaTeX Distribution**

   **Linux (Ubuntu/Debian)**:
   ```bash
   sudo apt-get update
   sudo apt-get install texlive-xetex texlive-fonts-extra
   ```

   **macOS**:
   ```bash
   brew install --cask mactex
   # Or download from: https://www.tug.org/mactex/
   ```

   **Windows**:
   - Download MiKTeX: https://miktex.org/download
   - Or TeX Live: https://www.tug.org/texlive/windows.html

4. **Calibri Font** (optional but recommended)

   **Included with**:
   - Windows (pre-installed)
   - Microsoft Office (any platform)

   **Linux installation**:
   ```bash
   # If you have a Windows partition or Office installation:
   sudo mkdir -p /usr/share/fonts/truetype/calibri
   sudo cp /path/to/calibri/*.ttf /usr/share/fonts/truetype/calibri/
   sudo fc-cache -f -v
   ```

   **Fallback**: The templates include a fallback to Source Sans Pro font (uncomment in `.tex` files)

5. **LaTeX Workshop Extension for VS Code** (recommended)
   - Install from Extensions Marketplace
   - Provides PDF preview, syntax highlighting, and compile shortcuts

### Optional Tools

- **Git**: For version control (recommended)
- **PDF viewer**: For previewing compiled documents

---

## Installation

### 1. Clone or Download Repository

```bash
git clone https://github.com/yourusername/job-forge.git
cd job-forge
```

Or download as ZIP and extract.

### 2. Verify XeLaTeX Installation

```bash
xelatex --version
```

You should see output like:
```
XeTeX 3.141592653-2.6-0.999993 (TeX Live 2023)
```

### 3. Test Calibri Font

```bash
fc-list | grep -i calibri
```

Should show Calibri font paths if installed. If not, see [Prerequisites](#prerequisites) for installation.

### 4. Open in VS Code

```bash
code .
```

### 5. Configure Claude Code

1. Open VS Code Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
2. Type "Claude Code: Set API Key"
3. Enter your Anthropic API key
4. Restart VS Code if prompted

---

## Initial Setup

**Note for New Users**: After completing this section, you **must** also complete the [First-Time Setup: Customizing for Your Experience](#first-time-setup-customizing-for-your-experience) section below to replace the sample resume content with your own background.

### Configure Personal Information

This project uses a **centralized configuration system** to manage your personal information. Instead of editing it in multiple files, you configure it once and it applies everywhere automatically.

#### 1: Set Up LaTeX Configuration

Copy the LaTeX template and fill in your information:

```bash
cp config/personal-info.template.tex config/personal-info.tex
```

Then edit `config/personal-info.tex`:

```latex
\newcommand{\MyName}{Your Full Name}
\newcommand{\MyTitle}{Your Current Position}
\newcommand{\MyCity}{YourCity}
\newcommand{\MyState}{YourState}
\newcommand{\MyPhone}{(123) 456-7890}
\newcommand{\MyEmail}{your.email@gmail.com}
\newcommand{\MyLinkedIn}{linkedin.com/in/your-profile}
\newcommand{\MyGitHub}{github.com/your-profile}
```

**Important**:
- This file is gitignored and will never be committed
- All LaTeX documents automatically use these values via `\input{}`
- Update this file anytime your contact info changes

#### 2: Set Up Claude Code Configuration

Copy the markdown template and fill in the same information:

```bash
cp config/PERSONAL_INFO.template.md config/PERSONAL_INFO.md
```

Then edit `config/PERSONAL_INFO.md` with your information:

```markdown
## Contact Information

- **Name:** Your Full Name
- **Title:** Your Current Position
- **Location:** YourCity, YourState
- **Phone:** (123) 456-7890
- **Email:** your.email@gmail.com
- **LinkedIn:** linkedin.com/in/your-profile
- **GitHub:** github.com/your-profile
```

**Why two files?**
- `personal-info.tex` - Used by LaTeX when compiling PDFs
- `PERSONAL_INFO.md` - Read by Claude Code when generating materials

#### 3: Add Your Signature

1. Create a signature image (handwritten or digital)
2. Save as `signature.png` in the project root
3. Recommended size: 300x100 pixels (transparent background)
4. Format: PNG with transparent background

**To create a signature**:
- Handwrite on white paper, photograph, and remove background
- Use a drawing tablet or iPad
- Use online signature generators (e.g., MyLiveSignature.com)

**Note**:
- `signature.png` is gitignored and will not be committed
- If you skip this step, the templates will automatically use `sample-signature.png` as a fallback
- The sample signature displays placeholder text to remind you to add your own

---

## First-Time Setup: Customizing for Your Experience

**IMPORTANT**: This project includes sample resume content and work experience examples (Payment Platform Company, E-commerce Platform, etc.). These are **placeholder examples** that you **must replace** with your own background before using the system.

### Overview: What Needs Customization

The following files contain sample experience that must be replaced with yours:

1. **Resume variants** (`resumes/*/resume.tex`) - Sample resume with placeholder work history
2. **`.claude/skills/job-application-helper.md`** - Context about your experience for AI
3. **`.claude/prompts/*.md`** - Examples that reference sample companies
4. **`CLAUDE.md`** - Resume variant descriptions (optional to update)

### Recommended Workflow

**Do this in order:**

1. ✅ **Complete "Initial Setup" above** (configure personal info, signature)
2. 🎯 **Generate your first resume variant** (using AI prompt below) ← START HERE
3. 📝 **Update `.claude/skills/job-application-helper.md`** with your experience
4. 🔄 **Optionally update example text** in `.claude/prompts/*.md` files
5. ✨ **Start using `/new`** to create applications

---

### Step 1: Generate Your First Resume Variant (REQUIRED)

Before you can use the `/new` command, you need at least one resume variant tailored to your experience.

#### Option A: Use Claude to Generate Your Resume (Recommended)

Copy and paste this prompt into a Claude conversation:

```
I need help creating my first resume for the Job Forge system. Please follow these steps:

**STEP 1: Interview Me**

Ask me these questions one at a time and wait for my answers:

1. What is your full work history? For each role, provide:
   - Company name
   - Job title
   - Dates (Month Year - Month Year or "Present")
   - Employment duration in years/months
   - Brief description of the company/industry

2. For your MOST RECENT role, what are:
   - Your primary tech stack? (languages, frameworks, databases)
   - Key projects you worked on?
   - Quantifiable achievements? (metrics like: X% improvement, $Y revenue, Z users, etc.)
   - Scale metrics? (how many users, transactions, locations, data volume, etc.)

3. For your PREVIOUS roles (if applicable):
   - Tech stack for each
   - 2-3 major achievements with metrics

4. What are ALL technologies you've worked with? Include:
   - Frontend frameworks (React, Angular, Vue, etc.)
   - Backend languages/frameworks (Node.js, Python, Java, Go, etc.)
   - Databases (PostgreSQL, MongoDB, MySQL, Redis, etc.)
   - Cloud platforms (AWS, Azure, GCP)
   - Tools & other tech (Docker, Kubernetes, CI/CD, etc.)

5. What is your education background?
   - Degree(s)
   - School name(s)
   - Graduation year(s)
   - Any relevant coursework or honors

6. What TYPE of resume variant should this be?
   - Examples: "backend", "full-stack", "frontend", "senior-software-engineer", "devops"
   - Choose based on your target roles

**STEP 2: After I Answer All Questions**

Create a complete `resume.tex` file following these requirements:

1. **Use the LaTeX template structure** from `resumes/sample/resume.tex` as your guide
2. **Follow these LaTeX rules**:
   - Import personal info: `\input{../../config/personal-info}`
   - Use XeLaTeX with Calibri font (already in template)
   - Escape special characters: `\$` for $, `\%` for %, `\&` for &
   - Use en-dash for date ranges: `2020--2023` not `2020-2023`
   - Regular hyphens for hyphenated words: `full-stack` not `full--stack`

3. **Structure the resume with these sections**:
   - Professional Summary (3-4 sentences, emphasize matching tech for variant type)
   - Employment History (most recent first, with bullet points)
   - Technical Skills (organized by category)
   - Education

4. **Professional Summary guidelines**:
   - Lead with: "[Job title] with [X] years of experience building [type of systems] using [tech stack]"
   - Include 2-3 key achievements with metrics
   - Target length: 60-80 words

5. **Employment History guidelines**:
   - Use bullet points with strong action verbs (Built, Led, Designed, Optimized)
   - Include metrics wherever possible (percentages, dollar amounts, scale numbers)
   - Emphasize achievements relevant to the variant type
   - Format: \jobentry{Title}{Company Name}{Month Year--Month Year}{City, State}

6. **Technical Skills guidelines**:
   - Organize by category (Frontend, Backend, Databases, Cloud, Tools, etc.)
   - List technologies you're strongest in first
   - Be honest - only include tech you actually know

**STEP 3: Output Format**

Provide the complete LaTeX code in a code block I can copy directly into:
`resumes/{variant-name}/resume.tex`

Tell me:
- What directory to create: `resumes/{variant-name}/`
- How to compile: `cd resumes/{variant-name} && xelatex resume.tex`

**READY?** Start by asking me question 1 about my work history.
```

After Claude generates your resume:

1. **Create the directory**:
   ```bash
   mkdir -p resumes/backend  # or whatever variant name you chose
   ```

2. **Save the resume**:
   - Copy the generated LaTeX code
   - Save to `resumes/backend/resume.tex`

3. **Test compilation**:
   ```bash
   cd resumes/backend
   xelatex resume.tex
   ```

4. **Review the PDF** and iterate with Claude if needed

#### Option B: Manually Create Resume (Alternative)

If you prefer to create your resume manually:

1. **Copy the sample**:
   ```bash
   cp -r resumes/sample resumes/backend  # choose your variant name
   ```

2. **Edit `resumes/backend/resume.tex`** and replace:
   - Professional Summary (lines ~130-140)
   - All work experience entries (companies, dates, titles, bullets)
   - Technical Skills section
   - Education section

3. **Follow LaTeX syntax** from the sample template

---

### Step 2: Update AI Context Files (REQUIRED)

After creating your resume variant, update the context files so Claude knows about YOUR experience (not the sample experience).

#### A. Update `.claude/skills/job-application-helper.md`

**Open the file** and replace the following sections:

**Lines 5-43: Core Experience Summary**
- Replace "Payment Platform Company", "E-commerce Platform Company", etc. with YOUR companies
- Update tech stacks, dates, and achievements with YOUR experience
- Use the same format, just swap in your details

**Example format**:
```markdown
### Current Role: Your Company Name (2020-2025, 5 years)
- **Stack**: React, Node.js, PostgreSQL, AWS
- **Scale**: 10K → 100K users, $5M → $50M ARR
- **Key Projects**:
  - Built real-time analytics dashboard (40% reduction in query time)
  - Migrated monolith to microservices (3x throughput improvement)
```

**Lines 44-60: Key Metrics**
- Replace sample metrics with YOUR quantifiable achievements
- Include: performance improvements, scale metrics, cost savings, etc.
- Be specific and truthful

**Lines 61-82: Technology Stack Reference**
- List ALL technologies you've actually worked with
- Include years of experience for each major technology
- Organize by category (Languages, Frameworks, Databases, Cloud, Tools, etc.)

#### B. Copy-Paste Prompt for Bulk Updates (Optional)

If you want Claude to help update the example text across all `.claude/prompts/*.md` files, use this prompt:

```
I need to update the Job Forge `.claude/prompts/` files to replace sample company references with my actual experience.

**Current sample companies** (to be replaced):
- "Payment Platform Company" (2021-2026, 5 years)
- "E-commerce Platform Company" (2008-2019, 11 years)
- "Mining Software Company" (2020-2021, 1 year)

**My actual companies** (use these instead):
1. [Your Most Recent Company] ([Your dates], [X] years)
   - Role: [Your title]
   - Tech: [Your stack]

2. [Your Previous Company] ([Your dates], [X] years)
   - Role: [Your title]
   - Tech: [Your stack]

3. [Earlier Company if applicable] ([Your dates], [X] years)
   - Role: [Your title]
   - Tech: [Your stack]

**Total experience**: [X] years

**Instructions**:
1. Read these files:
   - `.claude/prompts/cover-letter-generation.md`
   - `.claude/prompts/resume-customization.md`
   - `.claude/prompts/fintech-healthtech-positioning.md`

2. Find all references to the sample companies

3. Replace them with my actual companies while:
   - Preserving the structure and formatting
   - Keeping the same number of examples
   - Maintaining LaTeX escaping rules
   - Preserving the intent of each example

4. Show me the changes before making them

Start by reading the first file and showing me what you found.
```

**Note**: This step is **optional**. The example text won't affect functionality, but updating it makes the prompts feel more personalized.

---

### Step 3: Update CLAUDE.md (Optional)

The `CLAUDE.md` file contains project-level documentation and examples. You may want to update:

**Resume Variants Section (lines 137-167)**:
- Update the variant descriptions to match YOUR resume variants
- Example: If you created `resumes/backend-python/`, add a description for it

**Applied Directory Section (lines 169-181)**:
- This lists existing applications and will populate as you use `/new`
- You can clear the sample list or leave it as-is

**This file is mostly for reference** - updating it is optional and won't affect the `/new` command functionality.

---

### Step 4: Verify Your Setup

Before using `/new`, verify everything is configured:

- [ ] Personal info configured in `config/personal-info.tex` and `config/PERSONAL_INFO.md`
- [ ] At least 1 resume variant created in `resumes/{variant-name}/resume.tex`
- [ ] Resume compiles successfully: `cd resumes/{variant-name} && xelatex resume.tex`
- [ ] `.claude/skills/job-application-helper.md` updated with YOUR experience
- [ ] (Optional) Updated example company names in `.claude/prompts/*.md` files

**You're ready!** Now you can use `/new` to create tailored job applications.

---

### Step 5: Initialize Git (Optional but Recommended)

Version control helps you track changes to your application materials and maintain a history of your customizations.

**If starting fresh:**

```bash
git init
git add .
git commit -m "Initial commit: Personalized job application system"
```

**If connecting to GitHub:**

```bash
git remote add origin https://github.com/yourusername/job-forge.git
git branch -M main
git push -u origin main
```

**Note**: The `.gitignore` file is already configured to exclude:
- Personal information files (`config/personal-info.tex`, `config/PERSONAL_INFO.md`)
- Your signature image (`signature.png`)
- Generated PDF files
- LaTeX auxiliary files

---

### Creating Additional Resume Variants (Optional)

After you've created your first resume variant, you may want to create additional variants for different role types (e.g., separate variants for "backend", "full-stack", "senior-staff").

**To create additional variants:**

1. **Copy your existing variant**:
   ```bash
   # Copy your first variant as a starting point
   cp -r resumes/backend resumes/full-stack
   ```

2. **Customize the new variant** by editing `resumes/full-stack/resume.tex`:
   - **Professional Summary** - Adjust emphasis for the new role type
   - **Work Experience** - Reorder bullets to highlight relevant experience
   - **Technical Skills** - Prioritize technologies for that role type

3. **Compile and review**:
   ```bash
   cd resumes/full-stack
   xelatex resume.tex
   ```

**Tips**:
- Create variants for your primary target role types (backend, full-stack, senior/staff, etc.)
- Each variant should emphasize different aspects of the same truthful experience
- Use the same work history and metrics, just reorder and re-emphasize

---

## Usage

### Creating a New Job Application

The primary workflow uses the `/new` slash command in Claude Code:

1. **Open VS Code** with the project
2. **Open Claude Code** panel (click icon in left sidebar)
3. **Type** `/new` and press Enter
4. **Follow the prompts**:

   ```
   Claude: What is the company name?
   You: Acme Corp

   Claude: Please paste the full job description.
   You: [paste entire job description]

   Claude: Which resume variant would you like to use?
   Available variants: full-stack, backend, senior-software-engineer

   You: backend

   Claude: Creating directory: /applied/acme-corp/

   I propose these tailoring changes to the resume:
   - Update Professional Summary to emphasize API design
   - Move microservices bullet points higher
   - Add specific database optimization examples

   Should I proceed with these changes?

   You: Yes

   Claude: ✓ Created /applied/acme-corp/acme-corp-resume.tex
           ✓ Created /applied/acme-corp/acme-corp-cover-letter.tex

   To compile PDFs:
   cd applied/acme-corp
   xelatex acme-corp-resume.tex
   xelatex acme-corp-cover-letter.tex
   ```

5. **Compile the PDFs**:
   ```bash
   cd applied/acme-corp
   xelatex acme-corp-resume.tex
   xelatex acme-corp-cover-letter.tex
   ```

6. **Review the output**:
   - Check `acme-corp-resume.pdf`
   - Check `acme-corp-cover-letter.pdf`
   - Make manual edits to `.tex` files if needed
   - Recompile after edits

### Manual Workflow (Without AI)

If you prefer to create applications manually:

1. **Create company directory**:
   ```bash
   mkdir -p applied/company-name
   ```

2. **Copy resume template**:
   ```bash
   cp resumes/full-stack/full-stack.tex applied/company-name/company-name-resume.tex
   ```

3. **Copy cover letter template**:
   ```bash
   cp resumes/sample/cover-letter.tex applied/company-name/company-name-cover-letter.tex
   ```

4. **Edit files manually** in VS Code

5. **Compile**:
   ```bash
   cd applied/company-name
   xelatex company-name-resume.tex
   xelatex company-name-cover-letter.tex
   ```

---

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

### Understanding the Config System

The `config/` directory contains your personal information in two formats:

**Templates (committed to git)**:
- `personal-info.template.tex` - LaTeX template with placeholders
- `PERSONAL_INFO.template.md` - Markdown template with placeholders

**Your personal files (gitignored, YOU create these)**:
- `personal-info.tex` - Your actual contact info for LaTeX
- `PERSONAL_INFO.md` - Your actual contact info for Claude Code

**How it works**:
1. Copy templates to create your personal files
2. Fill in your information once
3. All LaTeX files automatically import from `config/personal-info.tex`
4. Claude Code reads `config/PERSONAL_INFO.md` when generating materials
5. Your personal info never gets committed to git

---

## Customization Guide

### Adjusting AI Behavior

#### Cover Letter Style

Edit `.claude/prompts/cover-letter-generation.md` to adjust:

- **Length**: Change paragraph count or sentence guidelines
- **Tone**: Adjust formality level
- **Structure**: Modify opening/body/closing patterns
- **Emphasis**: Change what aspects of experience to highlight

### Creating New Resume Variants

To add a new resume variant (e.g., "frontend-focused"):

1. **Create directory**:
   ```bash
   mkdir resumes/frontend
   ```

2. **Copy base resume**:
   ```bash
   cp resumes/full-stack/full-stack.tex resumes/frontend/frontend.tex
   ```

3. **Customize content**:
   - Emphasize frontend experience
   - Reorder skills to prioritize frontend technologies
   - Adjust Professional Summary

4. **Use your new variant**: When running `/new`, select "frontend" when prompted for resume variant

### Adding Multiple Cover Letter Templates

You can create different cover letter styles:

1. **Create new template**:
   ```bash
   cp resumes/sample/cover-letter.tex resumes/sample/cover-letter-alternate.tex
   ```

2. **Modify LaTeX layout** as desired

3. **Update `.claude/commands/new.md`** to reference your preferred template

---

## Troubleshooting

### LaTeX Compilation Issues

#### "Calibri font not found"

**Solution 1**: Install Calibri font (see [Prerequisites](#prerequisites))

**Solution 2**: Use fallback font
1. Open your `.tex` file
2. Comment out lines 9-10:
   ```latex
   % \usepackage{fontspec}
   % \setmainfont{Calibri}
   ```
3. Uncomment lines 13-14:
   ```latex
   \usepackage[default]{sourcesanspro}
   \usepackage[T1]{fontenc}
   ```

#### "xelatex: command not found"

Install XeLaTeX (see [Prerequisites](#prerequisites))

#### "Missing character: There is no ‑ (U+2011)"

You have non-breaking hyphens in your text. Replace with regular hyphens:
- Search for `‑` (non-breaking hyphen, U+2011)
- Replace with `-` (regular hyphen)

#### Compilation hangs or errors

1. **Delete auxiliary files**:
   ```bash
   rm *.aux *.log *.out *.toc
   ```
2. **Compile again**:
   ```bash
   xelatex your-file.tex
   ```

### VS Code LaTeX Workshop Issues

#### PDF not generating automatically

1. Open VS Code settings (`Ctrl+,` or `Cmd+,`)
2. Search for "latex-workshop.latex.autoBuild.run"
3. Set to "onSave"

#### Preview not showing

1. Right-click `.tex` file in editor
2. Select "LaTeX Workshop: View LaTeX PDF" → "View in VS Code tab"

### Claude Code Issues

#### `/new` command not found

1. Verify `.claude/commands/new.md` exists
2. Restart VS Code
3. Try typing `/` to see available commands

#### AI generates poor cover letters

1. **Update context**: Edit `.claude/skills/job-application-helper.md` with more detailed experience
2. **Provide better job descriptions**: Paste the complete JD, not just a summary
3. **Give feedback**: Tell Claude what's wrong and ask it to regenerate

#### Wrong resume variant selected

You can override the selection:
- When Claude asks for approval, say "Use the backend variant instead"
- Or manually specify: "Create application for Acme Corp using backend resume"

### Git Issues

#### Accidentally committed PDFs

PDFs are ignored by default in `.gitignore`. If you committed them:

```bash
git rm --cached applied/**/*.pdf
git commit -m "Remove PDF files from tracking"
```

---

## Tips & Best Practices

### Resume Tips

1. **Use metrics**: Quantify everything (percentages, dollar amounts, time saved)
2. **Action verbs**: Start bullets with strong verbs (Built, Led, Designed, Optimized)
3. **Specificity**: "Optimized PostgreSQL queries" > "Improved database performance"
4. **Relevance**: Tailor each variant to different role types
5. **Recency**: Put most recent and relevant experience first
6. **Keep it fresh**: Update your base resumes as you gain new experience

### Cover Letter Tips

1. **Read the JD carefully**: Paste the complete job description for best AI results
2. **Research the company**: Mention their product, mission, or recent news
3. **Match their tone**: Formal company = formal letter, startup = conversational
4. **Show, don't tell**: Use specific examples with metrics instead of generic claims
5. **Connect the dots**: Explicitly link your experience to their requirements
6. **Proofread**: Always review AI-generated text before sending

### Workflow Tips

1. **Version control everything**: Commit after creating each application
   ```bash
   git add applied/company-name/
   git commit -m "Add application for Company Name"
   ```

2. **Track applications**: Add a spreadsheet or use a tool to track:
   - Company name
   - Date applied
   - Position
   - Status (applied, interview, offer, rejected)

3. **Batch similar roles**: If applying to multiple similar roles, generate one, review, then iterate

4. **Keep CLAUDE.md updated**: When you get new experience or skills, update the context file

5. **Test before mass applying**: Compile and review your first few applications carefully to ensure quality

### Maintaining Quality

1. **Review AI suggestions**: Don't blindly accept resume changes - ensure accuracy
2. **Fact-check metrics**: Keep numbers consistent across all materials
3. **No lies**: Only include experience and skills you actually have
4. **Professional tone**: Keep all materials professional (avoid slang, emojis, etc.)
5. **Consistent formatting**: Don't mix LaTeX commands if you edit manually

### Organization

Create a tracking system in the project:

**Optional: Create `TRACKING.md`**:
```markdown
# Application Tracker

| Company    | Role        | Date Applied | Status  | Notes                           |
|------------|-------------|--------------|---------|---------------------------------|
| Acme Corp  | Backend Eng | 2025-01-15   | Applied | Heard back, interview scheduled |
| Widget Inc | Full-Stack  | 2025-01-16   | Applied | Awaiting response               |
```

---

## Advanced Usage

### Compiling Multiple Documents

Create a shell script `compile-all.sh`:

```bash
#!/bin/bash
# Compile all resumes and cover letters in a directory

for dir in applied/*/; do
    echo "Compiling $dir..."
    cd "$dir"
    for file in *.tex; do
        xelatex "$file" > /dev/null 2>&1
        echo "  ✓ $file"
    done
    cd ../..
done
echo "Done!"
```

Make executable and run:
```bash
chmod +x compile-all.sh
./compile-all.sh
```

### Continuous Compilation

For active editing, use LaTeX Workshop's auto-compile feature, or watch files manually:

```bash
# Install entr (file watcher)
# Ubuntu: sudo apt-get install entr
# macOS: brew install entr

# Watch and auto-compile
ls *.tex | entr xelatex -halt-on-error /_
```

### Batch Processing with AI

Apply to multiple roles at once:

1. Create a file `applications.txt`:
   ```
   Acme Corp|Backend Engineer|[job description here]
   Widget Inc|Full-Stack Engineer|[job description here]
   ```

2. Ask Claude Code:
   ```
   Process applications.txt and create application materials for each company
   ```

---

## Contributing

If you improve this system:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

Ideas for contributions:
- Additional resume templates
- New cover letter styles
- Better AI prompts
- Automation scripts
- Integration with job boards

---

## License

This project is released under the MIT License. Feel free to use, modify, and distribute as needed.

---

## Support

For issues or questions:

1. **LaTeX issues**: Check [LaTeX Stack Exchange](https://tex.stackexchange.com/)
2. **Claude Code issues**: See [Claude Code documentation](https://docs.claude.com/claude-code)
3. **Project issues**: Open an issue on GitHub

---

## Acknowledgments

- Built with [Claude Code](https://claude.com/claude-code) by Anthropic
- LaTeX templates inspired by modern resume design principles
- Font: Calibri by Microsoft Typography

---

**Good luck with your job search!** 🚀
