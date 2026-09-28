# Language

- **Conversation**: always in Italian. The user reads English and Italian equally well,
  but writes faster in Italian.
- **Artifacts**: always in English. Artifacts are code and documentation that end up in a
  repository: code, identifiers, code comments, docstrings, commit messages,
  PR titles/descriptions, issues, READMEs and other repo docs.
- **Not artifacts — any language is fine**: Claude's own memory notes, and personal
  reminder/to-do/notes files outside of repos (e.g. `~/migrazione/CLAUDE.md`).
  When editing one, just follow the language already used there.

# Engineering: performance-sensitive and embedded code

Learned the hard way: code that passes every test can still carry the shape of
whatever it was derived from, at a cost no behavioural test sees.

- **Derive from the platform, not from the sibling port.** When the same function
  is written for a new chip, OS or backend, copy the interface; write the
  implementation from THAT platform's documentation, starting from an inventory of
  what it offers that bears on cost (FIFOs, DMA, hardware counters, atomic
  set/clear registers, batching APIs, zero-copy paths) - each used or declined
  with a reason.
- **A comment justifies from the source, never from genealogy.** "As the other
  implementation does" is a fact about another platform, not a reason.
- **Read the reference implementation first** (the vendor's library, the
  platform's own examples) as an oracle of shape and cost - never as code to copy.
  Losing to it is allowed; a large gap is a finding to explain.
- **Cost is part of done.** For a hot path: cycles per unit of work, interrupts or
  syscalls per unit, time spent with interrupts masked or locks held - counted,
  measured, and written down beside the hardware's own limit.
- **Measured is not explained.** A measured rate far from the physical limit (the
  wire, the bus, the disk) is a finding to investigate, never a number to file.
- **Read the hot path in the compiler's output.** The source hides outlined
  lambdas, copies and calls; no call per byte or per frame, loop-invariant
  fields out of the loop.
- **Configure once, operate minimally.** What is constant for a binding is set and
  validated when the binding is made; each operation touches only what changes.
- **A lock or masked section covers the decision, not the work** - a claim, a
  test-and-set; never a register programming sequence, a copy or a spin.
- **Interfaces take runs, not items.** A transfer API takes a buffer and a length;
  a single element is its degenerate case, not its unit.
- **Rules ask questions, they do not fix answers.** DMA, FIFOs and batching are not
  always better (energy, latency, a tail that waits); the rule is to ask and
  measure before choosing.
