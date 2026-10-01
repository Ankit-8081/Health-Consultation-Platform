## What changed
<!-- One or two sentences. -->

## Linked issue
Closes #

## How to test
<!-- Steps a teammate can follow, e.g. log in as patient, book 10:00 slot. -->

## Checklist
- [ ] `mvn -B verify` passes locally
- [ ] Has a JUnit test for the service or DAO I changed
- [ ] No SQL in servlets or JSP, no scriptlets in JSP
- [ ] All SQL uses `PreparedStatement`
- [ ] Errors show a friendly message (no stack trace)
- [ ] I did not change `schema.sql` or `docs/UI_Handoff_Spec.md` (those go through the Team Lead)
