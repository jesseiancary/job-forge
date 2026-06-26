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

1. Read `config/PERSONAL_INFO.md` for contact information (if needed)
2. Read `resumes/sample/cover-letter.tex` template
3. Read `CLAUDE.md` for experience context
4. Use `.claude/prompts/cover-letter-generation.md` guidelines
5. Generate cover letter body text (3-4 paragraphs) tailored to:
   - Company mission and values
   - Specific role requirements
   - Relevant experience highlights
   - Technology stack alignment

6. Replace `COMPANY_NAME` with actual company name in salutation
7. Replace `BODY_TEXT` with generated paragraphs
8. Write to `applied/{company-slug}/{company-slug}-cover-letter.tex`

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
