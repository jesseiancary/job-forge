---
description: Create a new job application with tailored resume and cover letter
---

You are helping create a new job application package. Follow these steps carefully:

## Step 1: Gather Information

Ask the user for the following information in order:

1. **Company Name**: "What is the company name?"
   - Wait for response
   - Convert to kebab-case slug format:
     - Insert hyphens before capital letters (except first): "TechCorp" → "Tech-Corp"
     - Convert to lowercase: "Tech-Corp" → "tech-corp"
     - Replace spaces with hyphens: "Acme Corp" → "acme-corp"
     - Remove special characters: "Acme & Co." → "acme-co"
     - Examples: "AcmeCorp" → "acme-corp", "WeWork" → "we-work", "JP Morgan" → "jp-morgan"

2. **Job Description**: "Please paste the full job description."
   - Wait for complete job description

3. **Resume Variant**: List available resume variants and ask user to select:
   - "Which resume variant would you like to use?"
   - List all directories found in `resumes/` (excluding `sample/`)
   - Show format: "Available variants: full-stack, backend, full-stack-healthcare, senior-software-engineer"
   - Wait for user selection
   - If invalid selection, ask again

4. **Cover Letter**: Ask if user wants a cover letter generated:
   - "Would you like me to generate a cover letter? (yes/no)"
   - Wait for response
   - Accept variations: "yes", "y", "no", "n" (case-insensitive)

## Step 2: Analyze Job Description

Read and analyze the job description to determine:

1. **Key Technologies & Focus Areas** to emphasize in customization based on the job description

## Step 3: Create Directory

Create directory at: `applied/{company-slug}/`

Example: `applied/tech-corp/` (for "TechCorp")

## Step 4: Resume Customization (WITH USER CONFIRMATION)

1. Read `config/PERSONAL_INFO.md` for contact information
2. Read the user-selected resume file from `resumes/{variant}/resume.tex`
3. Read `CLAUDE.md` for context on experience and metrics
4. Use `.claude/prompts/resume-customization.md` guidelines to analyze tailoring needs
5. Analyze what should be tailored based on job description:
   - Professional Summary adjustments
   - Experience bullet point reordering
   - Technology emphasis
   - Role-specific customization patterns
6. **Present proposed changes to the user** with clear explanation:
   - Which variant you're using: `{variant}.tex`
   - What sections will be modified
   - What will be emphasized
   - What language/keywords will be added
7. **Wait for user approval** before making changes
8. After approval, copy resume to `applied/{company-slug}/{company-slug}-resume.tex` with modifications

## Step 5: Cover Letter Generation (CONDITIONAL - NO CONFIRMATION IF REQUESTED)

**Only proceed if user answered "yes" to cover letter question in Step 1.**

If user answered "no", skip to Step 6.

### Analysis Phase (CRITICAL - Do This First!)

1. **Extract company names from selected resume variant**
   - Read `resumes/{variant}/resume.tex` to get ACTUAL company names
   - Example: "Up 'n go Contactless Payments", "Infomercial.tv", "Hexagon Mining"
   - Do NOT use placeholder names like "Payment Platform Company" or "E-commerce Platform Company"

2. **Deeply analyze the job description**
   - Exact role title
   - Company mission/values
   - Technology stack (match their terminology)
   - Key responsibilities they emphasize
   - Scale/impact signals
   - Company culture (mission-driven? technical/craft? high-velocity?)
   - Domain (HealthTech, FinTech, SaaS, etc.)

3. **Map experience to their needs**
   - Select 4-6 MOST relevant achievements that match their requirements
   - Which metrics align with their scale?
   - Which technologies match their stack?
   - What narrative arc connects your experience to their challenge?

4. **Read context files**
   - Read `config/PERSONAL_INFO.md` for contact information (if needed)
   - Read `CLAUDE.md` for experience context and metrics reference
   - Read `.claude/prompts/cover-letter-generation.md` as phrasing pattern guide (NOT template!)

### Generation Phase

5. **Write fresh, original prose** tailored to THIS specific role:
   - Paragraph 1 (2-3 sentences): Opening hook connecting their challenge to your experience
   - Paragraph 2 (3-4 sentences): Recent role with 3-4 MOST relevant achievements
   - Paragraph 3 (2-3 sentences): Earlier experience OR mission/culture closing
   - Use real company names from resume variant
   - Match their language from the JD
   - Total: ~200-250 words

6. **Build the cover letter file**
   - Read `resumes/sample/cover-letter.tex` template
   - Replace `COMPANY_NAME` with actual company name in salutation
   - Replace `BODY_TEXT` with your generated paragraphs
   - Write to `applied/{company-slug}/{company-slug}-cover-letter.tex`

**IMPORTANT:**
- **Generate from scratch** - Do NOT copy example paragraphs from guidelines and do find-replace
- **Use guidelines as pattern reference** - Learn phrasing styles, don't template
- **Use real company names** - Extract from resume variant, never use placeholders
- **Be highly selective** - Choose 4-6 most relevant achievements, not everything
- **Match their language** - Use exact terms and phrases from their JD
- **Show understanding** - Demonstrate you researched their product/mission

**Note**: The cover letter template uses `\input{../config/personal-info}` to import contact information automatically, so you don't need to manually replace personal info fields.

## Step 6: Confirm Completion

Provide summary based on what was created:

**If cover letter was generated:**
```
✓ Created /applied/{company-slug}/{company-slug}-resume.tex (tailored {variant} resume)
✓ Created /applied/{company-slug}/{company-slug}-cover-letter.tex (generated cover letter)

To compile PDFs:
cd applied/{company-slug}
xelatex {company-slug}-resume.tex
xelatex {company-slug}-cover-letter.tex
```

**If cover letter was NOT generated:**
```
✓ Created /applied/{company-slug}/{company-slug}-resume.tex (tailored {variant} resume)

To compile PDF:
cd applied/{company-slug}
xelatex {company-slug}-resume.tex
```

## Important Notes

- **Always use the job-application-helper skill** at `.claude/skills/job-application-helper.md` for context
- **Use resume customization guidelines** at `.claude/prompts/resume-customization.md` for tailoring resumes
- **Use cover letter generation guidelines** at `.claude/prompts/cover-letter-generation.md` for generating cover letters
- **Follow LaTeX syntax rules** from `.claude/skills/latex.md` - escape special characters properly
- **Ask the user which resume variant to use** - Do NOT auto-select based on job description
- **Ask the user if they want a cover letter** - Do NOT assume they always want one
- Resume changes require user approval
- Cover letter generation is optional (user chooses in Step 1)
- If requested, cover letter generation does NOT require approval of content (auto-generated)
- Use regular hyphens (-) not non-breaking hyphens (‑) in all files
- Ensure signature path `../signature.png` is correct
- Follow the customization patterns from CLAUDE.md
- Keep metrics consistent based on user's experience
