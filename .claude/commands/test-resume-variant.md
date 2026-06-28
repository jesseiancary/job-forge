---
description: Test JSON → LaTeX → PDF round-trip for resume variant to ensure template accuracy
---

You are testing the resume rendering pipeline: structured JSON → Jinja2 LaTeX template → PDF compilation.

## Purpose

This command validates that:
1. Jinja2 templates correctly render JSON to LaTeX
2. LaTeX compiles to PDF without errors
3. Round-trip accuracy (JSON → LaTeX → JSON should match ~95%)
4. Character escaping works correctly
5. PDF output looks correct

## Step 1: Select Test Data

Ask user what to test:

**Options:**
1. Test with sample JSON (hardcoded test data)
2. Test with parsed resume variant (from `/tmp/parsed-resumes/`)
3. Test with custom JSON file (user provides path)

**Example:**
```
What would you like to test?
1. Sample JSON (hardcoded test data)
2. Parsed resume variant
3. Custom JSON file

Your choice (1-3):
```

If option 2, list available parsed JSON files:
```
Available parsed variants:
- full-stack.json
- backend.json
- senior-staff.json

Which variant?
```

## Step 2: Load or Generate Test Data

### Option 1: Sample JSON

Use this minimal test JSON:

```json
{
  "personal_info": {
    "name": "Test User",
    "title": "Software Engineer",
    "location": "San Francisco, CA",
    "phone": "(555) 123-4567",
    "email": "test@example.com",
    "linkedin": "linkedin.com/in/testuser",
    "github": "github.com/testuser"
  },
  "summary": "Test summary with $1B+ revenue and 95% uptime metrics.",
  "experience": [
    {
      "company": "TestCorp",
      "title": "Senior Engineer",
      "location": "San Francisco, CA",
      "dates": "Jan 2020 – Present",
      "bullets": [
        "Built payment system processing $1B+ annually with <0.5% error rate",
        "Improved performance by 40% using Redis caching & database optimization",
        "Led team of 5 engineers building multi-tenant SaaS platform"
      ]
    }
  ],
  "education": [
    {
      "institution": "Test University",
      "degree": "B.S. Computer Science",
      "location": "Berkeley, CA",
      "dates": "2003 – 2007"
    }
  ],
  "skills": {
    "languages": ["Python", "TypeScript", "Go"],
    "frameworks": ["FastAPI", "React", "Node.js"],
    "databases": ["PostgreSQL", "MongoDB", "Redis"],
    "tools": ["Docker", "AWS", "Git"]
  }
}
```

### Option 2/3: Load from File

Read the JSON file and validate structure.

## Step 3: Render JSON to LaTeX

Use Jinja2 to render the JSON to LaTeX.

**Pseudocode:**
```python
from jinja2 import Environment, FileSystemLoader

# Load template
env = Environment(loader=FileSystemLoader('backend/templates'))
env.filters['escape_latex'] = escape_latex_filter
template = env.get_template('resume.tex.jinja2')

# Render
latex_output = template.render(
    personal_info=data['personal_info'],
    summary=data['summary'],
    experience=data['experience'],
    education=data['education'],
    skills=data['skills']
)

# Save to temp file
with open('/tmp/test-resume.tex', 'w') as f:
    f.write(latex_output)
```

## Step 4: Validate LaTeX Syntax

Check the generated LaTeX for common issues:

1. **Unescaped special characters:**
   - Search for bare `$`, `%`, `&`, `#`, `_` not preceded by `\`
   - Exception: `$...$` math mode is valid

2. **Unclosed environments:**
   - Check `\begin{itemize}` has matching `\end{itemize}`
   - Check `\begin{document}` has matching `\end{document}`

3. **Missing required packages:**
   - Check `\usepackage{fontspec}` present for XeLaTeX
   - Check `\setmainfont{Calibri}` or fallback font

4. **Broken line breaks:**
   - Check `\\` at end of lines where needed

**Report validation results:**
```
LaTeX Validation:
✓ No unescaped special characters
✓ All environments closed
✓ Required packages present
⚠ Warning: Non-breaking hyphen detected (will be replaced)
```

## Step 5: Compile LaTeX to PDF

Use XeLaTeX to compile the `.tex` file:

**Command:**
```bash
xelatex -output-directory=/tmp /tmp/test-resume.tex
```

**Expected output:**
- `/tmp/test-resume.pdf` created
- No errors in compilation log
- Warnings are acceptable (e.g., Overfull hbox)

**If compilation fails:**
1. Show the error message from XeLaTeX
2. Identify the problematic line number
3. Show context around the error
4. Suggest fix based on error type

**Common errors:**

| Error | Cause | Fix |
|-------|-------|-----|
| `! LaTeX Error: File 'fontspec.sty' not found` | Missing package | Install texlive-xetex |
| `! Undefined control sequence` | Typo in LaTeX command | Check template syntax |
| `! Missing $ inserted` | Unescaped `$` | Escape as `\$` |
| `! Extra alignment tab has been changed to \cr` | Unescaped `&` | Escape as `\&` |

## Step 6: Visual Inspection Checklist

After PDF is generated, ask user to review:

```
PDF generated: /tmp/test-resume.pdf

Please review the PDF and answer:
1. Does personal info display correctly? (Y/N)
2. Is the summary paragraph formatted correctly? (Y/N)
3. Are all experience bullets visible? (Y/N)
4. Do metrics display correctly ($1B+, 95%, etc.)? (Y/N)
5. Are dates formatted consistently? (Y/N)
6. Does the layout match the original resume? (Y/N)

Any issues found? (describe or type "none"):
```

## Step 7: Round-Trip Test (Optional)

To test parsing accuracy, parse the generated LaTeX back to JSON:

1. Parse `/tmp/test-resume.tex` using the LaTeX parser
2. Compare with original JSON
3. Calculate similarity score (percentage of fields matching)

**Metrics:**
- Summary match: 100% (exact) or < 100% (diff)
- Experience entries: Count match?
- Bullets per job: Count match?
- Bullet text: Fuzzy match (ignore whitespace)

**Example output:**
```
Round-Trip Test Results:
✓ Summary: 100% match
✓ Experience count: 3 → 3 ✓
✓ Bullet count: 12 → 12 ✓
⚠ Bullet text: 95% similarity (whitespace differences)

Overall round-trip accuracy: 97%
```

## Step 8: Character Escaping Test

Specifically test special characters:

**Test input JSON:**
```json
{
  "summary": "Test with $1B revenue, 95% uptime, <0.5% errors, R&D team, user_id field, ~250 users"
}
```

**Expected LaTeX output:**
```latex
Test with \$1B revenue, 95\% uptime, $<$0.5\% errors, R\&D team, user\_id field, $\sim$250 users
```

**PDF should display:**
```
Test with $1B revenue, 95% uptime, <0.5% errors, R&D team, user_id field, ~250 users
```

**Validation:**
- [ ] Dollar signs display correctly
- [ ] Percentages display correctly
- [ ] Less-than symbols display correctly
- [ ] Ampersands display correctly
- [ ] Underscores display correctly
- [ ] Tildes display correctly

## Step 9: Performance Test

Measure rendering and compilation time:

```
Performance Metrics:
- JSON → LaTeX rendering: 12ms
- LaTeX → PDF compilation: 1.2s
- Total round-trip: 1.21s

✓ Within acceptable range (<2s)
```

## Step 10: Report Summary

Generate final test report:

```markdown
# Resume Rendering Test Report

**Test Date:** 2026-06-27 20:00:00
**Test Data:** sample.json
**Template:** resume.tex.jinja2

## Results

### LaTeX Generation
✓ No syntax errors
✓ All special characters escaped correctly
✓ Rendering time: 12ms

### PDF Compilation
✓ Compilation succeeded
✓ No critical errors
⚠ 2 warnings (Overfull hbox - acceptable)
✓ Compilation time: 1.2s

### Visual Inspection
✓ Personal info correct
✓ Summary formatted correctly
✓ All bullets visible
✓ Metrics display correctly ($, %, etc.)
✓ Dates consistent
✓ Layout matches original

### Round-Trip Accuracy
✓ Summary: 100% match
✓ Experience count: 3/3
✓ Bullet count: 12/12
⚠ Bullet text: 95% similarity (minor whitespace diffs)
**Overall: 97% accuracy**

### Special Characters
✓ $ (dollar) → \$
✓ % (percent) → \%
✓ < (less than) → $<$
✓ & (ampersand) → \&
✓ _ (underscore) → \_
✓ ~ (tilde) → $\sim$

## Conclusion

✅ **Template is production-ready**

Minor issues:
- Whitespace normalization needed in round-trip parser
- Overfull hbox warnings (cosmetic, can ignore)

Recommended next steps:
1. Test with all resume variants
2. Add automated regression tests
3. Deploy to backend/templates/
```

## Important Notes

- **Use latex-specialist agent** - Leverage `.claude/agents/latex-specialist.md` for LaTeX expertise
- **XeLaTeX required** - Cannot use pdflatex (needs fontspec for Calibri)
- **Temp files** - Use `/tmp/` for test outputs to avoid cluttering repo
- **Manual review critical** - Automated checks catch syntax errors, human review catches layout issues
- **Regression suite** - Save successful test cases for future regression testing

## Common Issues & Fixes

### Issue: Font not found
**Error:** `Font 'Calibri' not found`
**Fix:** Use fallback font in template:
```latex
\IfFontExistsTF{Calibri}{\setmainfont{Calibri}}{\setmainfont{Arial}}
```

### Issue: Special char not escaped
**Error:** `! Missing $ inserted`
**Fix:** Update `escape_latex` filter to handle edge cases

### Issue: Line break issue
**Error:** PDF has run-on text
**Fix:** Check `\\` line breaks in template

### Issue: Round-trip mismatch
**Error:** Parsed JSON doesn't match original
**Fix:** Improve parser regex patterns
