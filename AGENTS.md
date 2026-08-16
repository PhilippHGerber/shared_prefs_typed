# shared_prefs_typed - Agent Guide

Type-safe SharedPreferences for Flutter via `build_runner` code generation.

## Principles

**Surgical.** Every changed line traces to the request. Match existing style. Remove only what your changes orphan.

**Minimal.** No speculative features, single-use abstractions, or impossible-scenario handling.

**Verifiable.** Transform tasks into testable goals — reproduce the bug first, then fix it.

## Project

See `AGENTS.md` for types, annotations, constraints, and testing patterns.

Use the **dart MCP server** for all Dart/Flutter operations instead of raw shell commands.

```bash
# All workspace tests
./script/test.sh

# Generator tests — must use dart VM, not flutter test
cd packages/shared_prefs_typed && dart test/generator_test.dart

# Single generator test by name
cd packages/shared_prefs_typed && dart test/generator_test.dart --name "async mode"
```

## Updating golden files

Use `helper/golden_gen` — never hand-write goldens:

```bash
cp packages/shared_prefs_typed/test/src/success_case.dart helper/golden_gen/lib/
cd helper/golden_gen && flutter pub run build_runner build
cp helper/golden_gen/lib/*.g.dart packages/shared_prefs_typed/test/goldens/
rm helper/golden_gen/lib/*_case.dart helper/golden_gen/lib/*_case.g.dart
# ↑ never rm *.dart — would delete main.dart
```

## Coverage

100% line coverage on `packages/shared_prefs_typed/lib/`. Run via dart MCP with `coverage: "coverage"`, then:

```bash
format_coverage --lcov --in=coverage/test --out=coverage/lcov.info --report-on=lib
```

## Linting

`very_good_analysis` — `page_width: 100`, `trailing_commas: preserve`, `prefer_relative_imports: true`. Generated `*.g.dart` and `test/src/` excluded.

## Agent skills

### Issue tracker

Issues live as local markdown files under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default label vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout — one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.
