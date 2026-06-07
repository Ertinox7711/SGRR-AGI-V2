---
paths: ["**/<your-project>/**"]
---
# Example project rule (lazy-loaded)

This file is loaded into context **only** when Claude reads or edits a file
whose path matches the `paths:` glob above — unlike `CLAUDE.md`, which loads
at every session.

Use this pattern to keep project-specific behavior out of your global context:

- One rule file per project, scoped with `paths:`.
- Put "how to behave in THIS project" instructions here (build commands,
  deploy steps, business constraints, pointer to the master memory).
- Your global `CLAUDE.md` stays light and universal.

Replace `<your-project>` above with the real name of your project folder, and
rewrite the body below for that project.

## <your-project> — autonomy

- Read this project's `CLAUDE.md` first if it exists (master memory).
- End-to-end autonomous: infer intent, act. Confirm only destructive actions
  and anything visible to others.
- Verify before declaring done: run the build / tests, read the diff.
