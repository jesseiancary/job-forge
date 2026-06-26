# Personal Information Configuration

This file contains your personal information used by Claude Code when generating application materials.

**SETUP INSTRUCTIONS:**
1. Copy this file to: `config/PERSONAL_INFO.md`
2. Replace all placeholder values with your actual information
3. Save the file (it will be gitignored)
4. Claude Code will automatically read this file when running `/new` command

**NOTE:** `config/PERSONAL_INFO.md` is gitignored for privacy. Only this template file is committed to the repository.

---

## Contact Information

- **Name:** Your Name
- **Title:** Your Current Position
- **Location:** City, State
- **Phone:** (987) 654-3210
- **Email:** your.email@gmail.com
- **LinkedIn:** linkedin.com/in/your-profile
- **GitHub:** github.com/your-profile

## Optional Information

Uncomment and fill in if you want to include these:

<!-- - **Website:** yourwebsite.com -->
<!-- - **Portfolio:** portfolio.yourwebsite.com -->
<!-- - **Twitter:** @yourhandle -->

---

## Usage

This file is referenced by:
- `.claude/commands/new.md` - When generating new application materials
- `.claude/skills/job-application-helper.md` - For context about your contact info

When Claude Code generates cover letters or customizes resumes, it will read this file to populate your contact information consistently across all documents.
