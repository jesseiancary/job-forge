# LaTeX Parser Skill Context

Context for parsing existing `.tex` resume/cover letter files to structured JSON.

## Purpose

Parse LaTeX files from the current file-based system into structured JSON for:
- Migration to MongoDB
- Web-based editing (drag-drop bullets)
- Multi-format export (future: Markdown, DOCX)

## Parsing Strategy

Use **regex-based parsing** for 90% automation, with manual review for edge cases.

## Key Regex Patterns

```python
import re
from typing import List, Dict

# Section extraction
SECTION_PATTERN = r'\\section\*?\{([^}]+)\}(.*?)(?=\\section|\\end\{document\})'

# Experience entry: \textbf{Company} -- Title
COMPANY_TITLE_PATTERN = r'\\textbf\{([^}]+)\}\s*--\s*([^\n\\]+)'

# Location and dates: \textit{Location} \hfill Dates
LOC_DATE_PATTERN = r'\\textit\{([^}]+)\}\s*\\\\hfill\s*([^\n]+)'

# Bullet points
BULLET_PATTERN = r'\\item\s+(.+?)(?=\\item|\\end\{itemize\})'

# Education: \textbf{Institution} -- Degree
EDU_PATTERN = r'\\textbf\{([^}]+)\}\s*--\s*([^\n\\]+)'
```

## Cleanup Functions

```python
def clean_latex(text: str) -> str:
    """Remove LaTeX formatting commands and unescape special chars."""
    # Remove formatting commands
    text = re.sub(r'\\textbf\{([^}]+)\}', r'\1', text)
    text = re.sub(r'\\textit\{([^}]+)\}', r'\1', text)
    text = re.sub(r'\\href\{[^}]+\}\{([^}]+)\}', r'\1', text)

    # Unescape special characters
    text = text.replace(r'\$', '$')
    text = text.replace(r'\%', '%')
    text = text.replace(r'\&', '&')
    text = text.replace(r'\_', '_')
    text = text.replace(r'\#', '#')

    # Replace non-breaking hyphen
    text = text.replace('\u2011', '-')

    return text.strip()
```

## Parsing Functions

```python
def parse_summary(tex_content: str) -> str:
    match = re.search(
        r'\\section\*?\{Professional Summary\}\s*(.+?)(?=\\section|\\end\{document\})',
        tex_content,
        re.DOTALL
    )
    if match:
        return clean_latex(match.group(1).strip())
    return ""

def parse_experience(tex_content: str) -> List[Dict]:
    # Extract experience section
    exp_match = re.search(
        r'\\section\*?\{Professional Experience\}(.+?)(?=\\section|\\end\{document\})',
        tex_content,
        re.DOTALL
    )
    if not exp_match:
        return []

    exp_section = exp_match.group(1)
    jobs = []

    # Split by company/title pattern
    for match in re.finditer(COMPANY_TITLE_PATTERN, exp_section):
        company = clean_latex(match.group(1))
        title = clean_latex(match.group(2))

        # Find location/dates after this match
        remaining = exp_section[match.end():]
        loc_date_match = re.search(LOC_DATE_PATTERN, remaining)

        if loc_date_match:
            location = clean_latex(loc_date_match.group(1))
            dates = clean_latex(loc_date_match.group(2))
        else:
            location, dates = "", ""

        # Extract bullets for this job
        bullets = extract_bullets_after_position(remaining)

        jobs.append({
            "company": company,
            "title": title,
            "location": location,
            "dates": dates,
            "bullets": bullets
        })

    return jobs

def extract_bullets_after_position(text: str) -> List[str]:
    # Find \begin{itemize}...\end{itemize}
    itemize_match = re.search(
        r'\\begin\{itemize\}(.+?)\\end\{itemize\}',
        text,
        re.DOTALL
    )
    if not itemize_match:
        return []

    itemize_content = itemize_match.group(1)
    bullets = []

    for bullet_match in re.finditer(BULLET_PATTERN, itemize_content, re.DOTALL):
        bullet_text = clean_latex(bullet_match.group(1).strip())
        bullets.append(bullet_text)

    return bullets
```

## Validation

```python
def validate_parsed_resume(data: Dict) -> List[str]:
    """Return list of validation issues."""
    issues = []

    if not data.get("summary"):
        issues.append("Missing summary")

    if not data.get("experience"):
        issues.append("No experience entries found")

    for i, job in enumerate(data.get("experience", [])):
        if not job.get("company"):
            issues.append(f"Job #{i+1}: Missing company")
        if not job.get("bullets"):
            issues.append(f"Job #{i+1}: No bullets found")
        for j, bullet in enumerate(job.get("bullets", [])):
            if len(bullet) < 20:
                issues.append(f"Job #{i+1}, Bullet #{j+1}: Too short (may be truncated)")

    return issues
```

## Manual Review Checklist

After parsing, review:
- [ ] Summary complete (not truncated)
- [ ] All experience entries present
- [ ] Bullet counts match original
- [ ] Dates consistent format
- [ ] Special characters unescaped correctly ($, %, etc.)
- [ ] No LaTeX commands remaining
- [ ] Education entries present

## Common Parsing Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| Truncated bullets | Regex doesn't handle multi-line bullets | Manually merge lines |
| Missing dates | Non-standard date format | Manually extract |
| Bold/italic lost | Markup removed during cleanup | Accept (MVP doesn't preserve emphasis) |
| Special chars wrong | Incomplete unescape mapping | Update `clean_latex()` |

## Testing Parsing Accuracy

```python
def test_parse_resume():
    with open('resumes/full-stack/resume.tex') as f:
        tex_content = f.read()

    result = parse_resume_to_json(tex_content)

    # Assertions
    assert result["summary"]
    assert len(result["experience"]) >= 2
    assert all(len(job["bullets"]) >= 2 for job in result["experience"])
    assert len(result["education"]) >= 1
```

## References

See `.claude/agents/latex-specialist.md` for full LaTeX parsing expertise.
