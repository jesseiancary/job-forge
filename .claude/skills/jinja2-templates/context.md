# Jinja2 LaTeX Templates Skill Context

Context for rendering structured JSON resume data to LaTeX using Jinja2 templates.

## Purpose

Render JSON resume data to LaTeX format for PDF compilation:
- JSON (from database) → Jinja2 template → LaTeX → PDF
- Supports dynamic bullet reordering (drag-drop UI)
- Character escaping for LaTeX special characters

## Template Setup

```python
from jinja2 import Environment, FileSystemLoader

def setup_jinja_env():
    env = Environment(
        loader=FileSystemLoader('apps/api/templates'),
        trim_blocks=True,
        lstrip_blocks=True
    )

    # Custom filter for LaTeX escaping
    env.filters['escape_latex'] = escape_latex_filter

    return env
```

## LaTeX Escape Filter

```python
def escape_latex_filter(text: str) -> str:
    """Escape special LaTeX characters."""
    if not text:
        return ""

    replacements = {
        '\\': r'\textbackslash{}',
        '&': r'\&',
        '%': r'\%',
        '$': r'\$',
        '#': r'\#',
        '_': r'\_',
        '{': r'\{',
        '}': r'\}',
        '~': r'\textasciitilde{}',
        '^': r'\textasciicircum{}',
        '<': r'$<$',
        '>': r'$>$',
    }

    for char, escaped in replacements.items():
        text = text.replace(char, escaped)

    return text
```

## Resume Template Example

```latex
{# templates/resume.tex.jinja2 #}
\documentclass[11pt]{article}
\usepackage{fontspec}
\setmainfont{Calibri}
\usepackage[margin=0.75in]{geometry}

\begin{document}

% Personal info imported from config
\input{../config/personal-info}

% Header
\begin{center}
{\LARGE \textbf{\MyName}} \\
\vspace{2mm}
\MyTitle \\
\MyCity, \MyState $\bullet$ \MyPhone $\bullet$ \MyEmail
\end{center}

% Professional Summary
\section*{Professional Summary}
{{ summary | escape_latex }}

% Professional Experience
\section*{Professional Experience}
{% for job in experience %}
\textbf{ {{ job.company | escape_latex }} } -- {{ job.title | escape_latex }} \\
\textit{ {{ job.location | escape_latex }} } \hfill {{ job.dates | escape_latex }}
\begin{itemize}
{% for bullet in job.bullets %}
  \item {{ bullet.text | escape_latex }}
{% endfor %}
\end{itemize}
{% if not loop.last %}\vspace{2mm}{% endif %}
{% endfor %}

% Education
\section*{Education}
{% for edu in education %}
\textbf{ {{ edu.institution | escape_latex }} } -- {{ edu.degree | escape_latex }} \\
\textit{ {{ edu.location | escape_latex }} } \hfill {{ edu.dates | escape_latex }}
{% endfor %}

% Skills
\section*{Technical Skills}
\textbf{Languages:} {{ skills.languages | join(', ') | escape_latex }} \\
\textbf{Frameworks:} {{ skills.frameworks | join(', ') | escape_latex }} \\
\textbf{Databases:} {{ skills.databases | join(', ') | escape_latex }} \\
\textbf{Tools:} {{ skills.tools | join(', ') | escape_latex }}

\end{document}
```

## Rendering JSON to LaTeX

```python
def render_resume_to_latex(resume_data: dict) -> str:
    env = setup_jinja_env()
    template = env.get_template('resume.tex.jinja2')

    latex_output = template.render(
        summary=resume_data['summary'],
        experience=resume_data['experience'],
        education=resume_data['education'],
        skills=resume_data['skills']
    )

    return latex_output
```

## PDF Compilation

```python
import subprocess
from pathlib import Path

def compile_latex_to_pdf(latex_content: str, output_dir: Path) -> Path:
    # Write to temp .tex file
    tex_file = output_dir / "resume.tex"
    tex_file.write_text(latex_content)

    # Compile with XeLaTeX
    result = subprocess.run(
        ['xelatex', '-output-directory', str(output_dir), str(tex_file)],
        capture_output=True,
        text=True,
        timeout=30
    )

    if result.returncode != 0:
        raise RuntimeError(f"LaTeX compilation failed:\n{result.stderr}")

    pdf_file = output_dir / "resume.pdf"
    if not pdf_file.exists():
        raise RuntimeError("PDF not generated")

    # Cleanup .aux, .log, .out
    for ext in ['.aux', '.log', '.out']:
        (output_dir / f"resume{ext}").unlink(missing_ok=True)

    return pdf_file
```

## Cover Letter Template

```latex
{# templates/cover-letter.tex.jinja2 #}
\documentclass[11pt]{article}
\usepackage{fontspec}
\setmainfont{Calibri}
\usepackage[margin=1in]{geometry}

\begin{document}

% Personal info
\input{../config/personal-info}

% Header
\noindent
\MyName \\
\MyCity, \MyState \\
\MyPhone $\bullet$ \MyEmail

\vspace{10mm}

\noindent
Dear {{ company_name | escape_latex }} Hiring Team,

\vspace{5mm}

{% for paragraph in body_paragraphs %}
{{ paragraph | escape_latex }}

{% if not loop.last %}\vspace{3mm}{% endif %}
{% endfor %}

\vspace{5mm}

\noindent
Sincerely,

\vspace{5mm}

\includegraphics[width=2in]{../signature.png}

\noindent
\MyName

\end{document}
```

## Best Practices

1. **Always use escape_latex filter** - For user-generated content
2. **Test with special characters** - Verify $, %, <, >, &, etc.
3. **Use trim_blocks and lstrip_blocks** - Prevent extra whitespace
4. **Cache rendered LaTeX** - Store in resume_variant.latex_source
5. **Regenerate on update** - Clear cache when JSON changes

## Testing Templates

```python
def test_resume_template():
    test_data = {
        "summary": "Test with $1B and 95% metrics",
        "experience": [{
            "company": "TechCorp",
            "title": "Engineer",
            "location": "SF, CA",
            "dates": "2020 – 2023",
            "bullets": [{"text": "Built system with <0.5% error rate"}]
        }],
        "education": [...],
        "skills": {...}
    }

    latex = render_resume_to_latex(test_data)

    # Assertions
    assert r'\$1B' in latex  # Dollar escaped
    assert r'95\%' in latex  # Percent escaped
    assert r'$<$0.5\%' in latex  # Less-than in math mode
    assert r'\textbf{TechCorp}' in latex
```

## References

- [Jinja2 Documentation](https://jinja.palletsprojects.com/)
- See `.claude/agents/latex-specialist.md` for LaTeX expertise
