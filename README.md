# SysML Domain Libraries

This repository is a home for reusable SysML v2 domain libraries.

It started with software-focused libraries, but the intent is broader: over time this repo can host multiple domain families, each with its own workspace, examples, and supporting rule catalogs.

## Repository Direction

The goal is to keep domain content:

- modular
- reusable across example workspaces
- organized by domain family instead of mixing everything into one large library

That means `software/` is the first domain workspace, not necessarily the last one.

Future top-level directories might cover other areas such as hardware, systems engineering, operations, manufacturing, or other domain-specific libraries as they emerge.

## Current Structure

- `software/` - the current software domain-library workspace
- `software/README.md` - detailed overview of the software libraries, overlays, rules, and examples

## Working Approach

Each domain family can evolve as a mostly self-contained workspace with:

- reusable SysML library packages
- small examples and reference workspaces
- descriptive rule catalogs for future tooling

This keeps each domain coherent on its own while still allowing cross-domain growth at the repository level.

## Current Status

Today, the software domain is the primary implemented area in this repository. If you want to explore the existing content, start with [software/README.md](/C:/Git/sysml-domain-libraries/software/README.md).
