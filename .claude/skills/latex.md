# LaTeX Skill

This skill provides essential LaTeX syntax reference for creating and editing resume and cover letter files.

## Characters That Must Be Escaped

The following characters have special meaning in LaTeX and **must be escaped with a backslash** when used as literal text:

| Character | Escaped Form | Purpose (when not escaped) |
|-----------|--------------|----------------------------|
| `$`       | `\$`         | Math mode delimiter |
| `%`       | `\%`         | Comment character |
| `&`       | `\&`         | Table column separator |
| `#`       | `\#`         | Macro parameter |
| `_`       | `\_`         | Math subscript |
| `{`       | `\{`         | Group start |
| `}`       | `\}`         | Group end |
| `~`       | `\~{}`       | Non-breaking space |
| `^`       | `\^{}`       | Math superscript |
| `\`       | `\textbackslash` | Command prefix |

**Common mistake**: Writing `$1B+` instead of `\$1B+` (dollar sign must be escaped)

## Special Characters and Symbols

### Approximation and Math Symbols

| Symbol | LaTeX Code | Usage Example |
|--------|------------|---------------|
| ~      | `$\sim$`   | `$\sim$250 to 2,000+ locations` (approximately 250) |
| ≈      | `$\approx$` | `$\approx$100K transactions` |
| ±      | `$\pm$`    | `$\pm$5\% variance` |
| ×      | `$\times$` | `3$\times$ faster` |
| ≤      | `$\leq$`   | `$\leq$500ms latency` |
| ≥      | `$\geq$`   | `$\geq$99.9\% uptime` |
| <      | `$<$`      | `$<$0.5\% false positives` |
| >      | `$>$`      | `$>$1M transactions` |

**Note**: These symbols require math mode (enclosed in `$...$`)

### Currency and Financial Symbols

| Symbol | LaTeX Code | Usage Example |
|--------|------------|---------------|
| $      | `\$`       | `\$1B+ annually` |
| $~     | `\$$\sim$` | `\$$\sim$100K to \$1M` (approximately $100K to $1M) |
| €      | `\texteuro` or `€` (with XeLaTeX) | `\texteuro 50M` |
| £      | `\pounds` or `£` (with XeLaTeX) | `\pounds 1M` |

**Important**: Always escape the dollar sign: `\$` not `$`

### Common Typographic Symbols

| Symbol | LaTeX Code | Usage Example |
|--------|------------|---------------|
| --     | `--`       | En dash for ranges: `2021--2026` |
| ---    | `---`      | Em dash for breaks: `payment flows---critical systems` |
| "..."  | `` `text' `` or `"text"` (XeLaTeX) | Use straight quotes with XeLaTeX/fontspec |
| ...    | `\ldots` or `...` | `Node.js, Express\ldots` |
| •      | `\textbullet` | Used in resume bullet lists |

### Percentage and Units

| Symbol | LaTeX Code | Usage Example |
|--------|------------|---------------|
| %      | `\%`       | `95\% reduction` |
| #      | `\#`       | `\#1 ranked` |

## Math Mode (`$...$`)

Use math mode for:
- Mathematical symbols: `$\sim$`, `$\times$`, `$\leq$`, `$<$`
- Subscripts/superscripts: `O(n$^2$)`, `H$_2$O`
- Equations or formulas

**Do NOT use math mode for**:
- Dollar signs: Use `\$` not `$\$$`
- Regular text: Keep it outside math mode

## Special Spacing

| Type | LaTeX Code | Usage |
|------|------------|-------|
| Non-breaking space | `~` | `Dr.~Smith`, `Figure~1` |
| Thin space | `\,` | Between number and unit: `5\,GB` |
| Negative space | `\!` | Fine-tuning spacing |
| Explicit space | `\ ` (backslash-space) | Force space after command |

## Common Patterns in This Project

### Approximate Numbers
```latex
$\sim$250 to 2,000+ locations
$\sim$100K to over 1.5M transactions
```

### Currency Ranges
```latex
\$1B+ annually
processing \$1B+ in annual transaction volume
```

### Percentages
```latex
99.95\% uptime
reducing costs by 35\%
```

### Comparison Operators in Text
```latex
$<$0.5\% false positives
$>$1M monthly transactions
```

### Date Ranges
```latex
APR 2021 -- APR 2026  (use -- for en dash)
```

## Hyperlinks

### Email Links
```latex
\href{mailto:your.email@gmail.com}{\MyEmail}
```

### URL Links
```latex
\href{https://linkedin.com/in/yourprofile}{\MyLinkedIn}
\href{https://github.com/yourprofile}{\MyGitHub}
```

**Note**: URLs in `\href{}` don't need escaping (e.g., `_` is fine in URLs)

## Common Mistakes to Avoid

1. **Forgetting to escape dollar signs**
   - ❌ `$1B+ annually`
   - ✅ `\$1B+ annually`

2. **Using wrong hyphen/dash**
   - ❌ `2021-2026` (single hyphen)
   - ✅ `2021--2026` (en dash for ranges)

3. **Escaping inside math mode**
   - ❌ `\$$\sim$` (don't escape inside math mode)
   - ✅ `\$$\sim$` (wait, this is wrong - see next)
   - ✅ `\$$\sim$250` (escape the first $, math mode for ~)

4. **Using math mode for dollars**
   - ❌ `$\$1B$` (dollar inside math mode)
   - ✅ `\$1B+` (escaped dollar, no math mode)

5. **Using non-breaking hyphens**
   - ❌ `‑` (Unicode U+2011, will cause font warnings)
   - ✅ `-` (regular ASCII hyphen)

6. **Forgetting to escape percentages**
   - ❌ `95% reduction`
   - ✅ `95\% reduction`

## XeLaTeX Specifics (Used in This Project)

This project uses **XeLaTeX** (not pdflatex), which allows:
- Unicode characters directly in source
- TrueType/OpenType fonts (Calibri via `fontspec`)
- Straight quotes: `"text"` instead of `` `text' ``

**Still required**:
- Escape special characters: `\$`, `\%`, `\&`, `\#`, `\_`
- Use math mode for symbols: `$\sim$`, `$\times$`

## Testing Your LaTeX

Compile with XeLaTeX:
```bash
xelatex yourfile.tex
```

Common errors:
- `Missing $ inserted` → You used `_` or `^` outside math mode
- `Undefined control sequence` → Typo in command name
- `Missing character: There is no ‑` → Used Unicode non-breaking hyphen instead of regular `-`

## Quick Reference for This Project

When writing resume/cover letter content:

```latex
% Approximate numbers
$\sim$250 to 2,000+ locations

% Currency
\$1B+ annually

% Percentages
99.95\% uptime

% Ranges
APR 2021 -- APR 2026

% Less than / Greater than
$<$0.5\% false positives
$>$1M transactions

% Email/URLs (already handled in template)
\href{mailto:\MyEmail}{\MyEmail}
```

**Golden Rule**: If you see a compilation warning or error, check escaping first.
