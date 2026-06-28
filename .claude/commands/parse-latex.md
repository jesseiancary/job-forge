---
description: Parse existing LaTeX resume/cover letter files to structured JSON for migration
---

You are helping parse existing LaTeX `.tex` files into structured JSON format for database migration.

## Purpose

This command parses LaTeX resume/cover letter files from the current file-based system into structured JSON that can be:
1. Stored in MongoDB
2. Edited via web UI (two-pane editor with drag-drop bullets)
3. Rendered back to LaTeX using Jinja2 templates

## Step 1: Select Files to Parse

Ask the user which files to parse:

**Options:**
1. Parse all resume variants in `resumes/` directory
2. Parse specific resume variant (user specifies directory name)
3. Parse all applied resumes in `applied/` directory
4. Parse specific applied resume (user specifies company slug)
5. Parse sample cover letter template

**Example:**
```
What would you like to parse?
1. All resume variants
2. Specific resume variant
3. All applied resumes
4. Specific applied resume
5. Sample cover letter template

Your choice (1-5):
```

## Step 2: Read and Analyze LaTeX Files

For each selected file:

1. Read the `.tex` file content
2. Identify the document structure:
   - Personal info section (if inline)
   - Professional summary
   - Experience section (jobs + bullets)
   - Education section
   - Skills section
   - Additional sections (certifications, projects, etc.)

## Step 3: Parse to JSON Structure

Use `.claude/agents/latex-specialist.md` for parsing strategies.

### Resume JSON Structure

```json
{
  "metadata": {
    "source_file": "resumes/full-stack/resume.tex",
    "variant_name": "full-stack",
    "parsed_at": "2026-06-27T20:00:00Z",
    "parser_version": "1.0"
  },
  "personal_info": {
    "name": "Jesse Doe",
    "title": "Full-Stack Software Engineer",
    "location": "San Francisco, CA",
    "phone": "(555) 123-4567",
    "email": "jesse@example.com",
    "linkedin": "linkedin.com/in/jessedoe",
    "github": "github.com/jessedoe"
  },
  "summary": "17 years of experience building scalable web applications...",
  "experience": [
    {
      "company": "TechCorp",
      "title": "Senior Full-Stack Engineer",
      "location": "San Francisco, CA",
      "dates": "Jan 2020 – Present",
      "bullets": [
        "Built payment processing system handling $1B+ in annual transaction volume using Node.js, React, and PostgreSQL",
        "Reduced API response time by 40% through Redis caching and database query optimization",
        "Led team of 5 engineers in architecting multi-tenant SaaS platform serving 1,000+ organizations"
      ]
    },
    {
      "company": "StartupXYZ",
      "title": "Full-Stack Developer",
      "location": "Remote",
      "dates": "Mar 2018 – Dec 2019",
      "bullets": [
        "Developed real-time collaboration features using WebSockets and Redis pub/sub",
        "Implemented authentication system with JWT and OAuth2 supporting 50,000+ users"
      ]
    }
  ],
  "education": [
    {
      "institution": "University of California, Berkeley",
      "degree": "B.S. Computer Science",
      "location": "Berkeley, CA",
      "dates": "2003 – 2007"
    }
  ],
  "skills": {
    "languages": ["TypeScript", "Python", "Go", "JavaScript"],
    "frameworks": ["React", "Node.js", "FastAPI", "Express"],
    "databases": ["PostgreSQL", "MongoDB", "Redis"],
    "tools": ["Docker", "AWS", "GitHub Actions", "Terraform"]
  }
}
```

### Cover Letter JSON Structure

```json
{
  "metadata": {
    "source_file": "applied/tech-corp/tech-corp-cover-letter.tex",
    "company": "TechCorp",
    "parsed_at": "2026-06-27T20:00:00Z"
  },
  "company_name": "TechCorp",
  "body_paragraphs": [
    "I am applying for the Senior Full-Stack Engineer role at TechCorp...",
    "At my current role, I built a payment processing system handling $1B+ in annual transaction volume...",
    "I am excited about TechCorp's mission to democratize financial services..."
  ]
}
```

## Step 4: Parse LaTeX Content

### Extract Personal Info (if inline)

```python
import re

def extract_personal_info(tex_content: str) -> dict:
    # Name (usually in \LARGE or \Huge)
    name_match = re.search(r'\\textbf\{([^}]+)\}', tex_content)

    # Title (usually after name)
    title_match = re.search(r'\\\\\\s*(.+?)\\s*\\\\', tex_content)

    # Contact info (email, phone, etc.)
    email_match = re.search(r'([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})', tex_content)
    phone_match = re.search(r'\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}', tex_content)

    return {
        "name": name_match.group(1) if name_match else None,
        "email": email_match.group(1) if email_match else None,
        "phone": phone_match.group(1) if phone_match else None,
    }
```

### Extract Summary

```python
def extract_summary(tex_content: str) -> str:
    # Look for Professional Summary section
    summary_match = re.search(
        r'\\section\*?\{Professional Summary\}\\s*(.+?)(?=\\section|\\end\{document\})',
        tex_content,
        re.DOTALL
    )
    if summary_match:
        summary = summary_match.group(1).strip()
        # Clean LaTeX commands
        summary = re.sub(r'\\textbf\{([^}]+)\}', r'\1', summary)
        summary = re.sub(r'\\textit\{([^}]+)\}', r'\1', summary)
        return summary
    return ""
```

### Extract Experience

```python
def extract_experience(tex_content: str) -> list:
    # Find experience section
    exp_match = re.search(
        r'\\section\*?\{Professional Experience\}(.+?)(?=\\section|\\end\{document\})',
        tex_content,
        re.DOTALL
    )
    if not exp_match:
        return []

    exp_section = exp_match.group(1)

    # Extract individual jobs
    # Pattern: \textbf{Company} -- Title
    job_pattern = r'\\textbf\{([^}]+)\}\s*--\s*([^\\\n]+)'
    jobs = []

    for match in re.finditer(job_pattern, exp_section):
        company = match.group(1).strip()
        title = match.group(2).strip()

        # Extract location and dates (next line after title)
        # Pattern: \textit{Location} \hfill Dates
        loc_date_match = re.search(
            rf'{re.escape(match.group(0))}[^\n]*\n\\s*\\\\textit\{{([^}}]+)\}}\\s*\\\\hfill\\s*([^\n]+)',
            exp_section
        )

        location = loc_date_match.group(1).strip() if loc_date_match else ""
        dates = loc_date_match.group(2).strip() if loc_date_match else ""

        # Extract bullets (itemize environment)
        bullets = extract_bullets_after_position(exp_section, match.end())

        jobs.append({
            "company": company,
            "title": title,
            "location": location,
            "dates": dates,
            "bullets": bullets
        })

    return jobs

def extract_bullets_after_position(text: str, start_pos: int) -> list:
    # Find next \begin{itemize} after start_pos
    itemize_match = re.search(r'\\begin\{itemize\}(.+?)\\end\{itemize\}', text[start_pos:], re.DOTALL)
    if not itemize_match:
        return []

    itemize_content = itemize_match.group(1)

    # Extract \item entries
    bullets = []
    for bullet_match in re.finditer(r'\\item\s+(.+?)(?=\\item|$)', itemize_content, re.DOTALL):
        bullet_text = bullet_match.group(1).strip()
        # Clean LaTeX commands
        bullet_text = clean_latex(bullet_text)
        bullets.append(bullet_text)

    return bullets

def clean_latex(text: str) -> str:
    # Remove LaTeX commands
    text = re.sub(r'\\textbf\{([^}]+)\}', r'\1', text)
    text = re.sub(r'\\textit\{([^}]+)\}', r'\1', text)
    text = re.sub(r'\\href\{[^}]+\}\{([^}]+)\}', r'\1', text)
    text = re.sub(r'\\\$', '$', text)  # Unescape dollar signs
    text = re.sub(r'\\%', '%', text)   # Unescape percentages
    text = text.replace('\\&', '&')
    text = text.strip()
    return text
```

## Step 5: Validate Parsed JSON

After parsing, validate the structure:

1. **Check required fields:**
   - Summary exists and is not empty
   - At least one experience entry
   - Each experience has company, title, dates, and bullets
   - At least one education entry

2. **Check data quality:**
   - Bullets are complete sentences (not truncated)
   - Dates in consistent format
   - No LaTeX commands remaining in text
   - Special characters properly unescaped ($, %, etc.)

3. **Report parsing issues:**
   - List any missing sections
   - Highlight truncated or malformed bullets
   - Warn about unusual formatting

## Step 6: Output Results

For each parsed file, output:

1. **Parsed JSON** - Show formatted JSON structure
2. **Parsing stats:**
   - Number of experience entries
   - Number of bullets
   - Number of education entries
   - Parsing confidence (90-100% = good, <90% = needs manual review)
3. **Issues found** (if any):
   - Missing sections
   - Malformed content
   - Special character issues

**Example Output:**
```
✓ Parsed: resumes/full-stack/resume.tex

Stats:
- Experience entries: 3
- Total bullets: 12
- Education entries: 1
- Parsing confidence: 95%

Issues:
⚠ Bullet #5 may be truncated (ends with "...")
⚠ Special character in bullet #8: ">" should be "$>$"

JSON saved to: /tmp/parsed-resumes/full-stack.json
```

## Step 7: Save Parsed JSON

Ask user where to save the parsed JSON:

**Options:**
1. Save to `/tmp/parsed-resumes/` (temporary review)
2. Save to `backend/migrations/parsed-data/` (for migration script)
3. Don't save (just display)

## Important Notes

- **Use latex-specialist agent** - Leverage `.claude/agents/latex-specialist.md` for parsing strategies
- **Non-breaking hyphens** - Replace `\u2011` with regular `-`
- **Manual review required** - Parsing accuracy is ~90%, expect some manual fixes
- **Preserve metrics** - Ensure dollar amounts, percentages preserved correctly
- **Date formats** - Normalize date formats (e.g., "2020 – Present" vs "2020 - Present")

## Common Edge Cases

1. **Multiple formats for dates**
   - "Jan 2020 – Present"
   - "2020 – 2023"
   - "January 2020 to December 2023"

2. **Bold/italic in bullets**
   - `\textbf{React}` → "React" (preserve emphasis in JSON as plain text for MVP)

3. **Special metrics**
   - `\$1B+` → "$1B+"
   - `95\%` → "95%"
   - `$>$1M` → ">1M"

4. **Truncated bullets**
   - Bullets ending mid-sentence (parsing error)
   - Multi-line bullets split incorrectly
