# `rocq-lsp` frequently asked questions

 * [Why do you say so often "client" and "server", what does it mean?](#why-do-you-say-so-often-client-and-server-what-does-it-mean)
 * [How is `rocq-lsp` different from VSRocq?](#how-is-rocq-lsp-different-from-vsrocq)
    + [VSRocq "Legacy"](#vsrocq-legacy)
    + [VSRocq 2](#vsrocq-2)
 * [Is `rocq-lsp` limited to VSCode?](#is-rocq-lsp-limited-to-vscode)
 * [What part of the LSP protocol does `rocq-lsp` support?](#what-part-of-the-lsp-protocol-does-rocq-lsp-support)
 * [What is `rocq-lsp` roadmap?](#what-is-rocq-lsp-roadmap)
 * [How is `rocq-lsp` developed and funded?](#how-is-rocq-lsp-developed-and-funded)
 * [Is there more information about `rocq-lsp` design?](#is-there-more-information-about-rocq-lsp-design)

## Why do you say so often "client" and "server", what does it mean?

In the world of user interfaces for programming languages
(a.k.a. IDEs), "client/server" refer respectively to the editor and
the compiler of language checker which provides feedback to the
editor, that is to say, errors, warnings, syntax highlighting
information, etc...

This way, the editor don't need to know a lot about the language.

Thus, in `rocq-lsp` case we have:

- the client is Visual Studio Code plus the `rocq-lsp` extension, or
  some other editors such as Emacs or vim,
- the server is an extended Rocq binary `rocq-lsp`, which takes care of
  running and checking Rocq commands, among other tasks.

The client and the server communicate using the [Language Server
Protocol](https://microsoft.github.io/language-server-protocol/)
standard, thus, the `rocq-lsp` language server can be used from any
editor supporting this protocol.

## How is `rocq-lsp` different from VSRocq?

As of May 2025, two versions of VSRocq are available: VSRocq Legacy and
VSRocq 2. They are independent implementations that share the same name
and project page.

### VSRocq "Legacy"

[VSCoq Legacy](https://github.com/rocq-community/vscoq-legacy) or
"VSRocq 1" was developed by C. J. Bell, and later maintained by a team
of volunteers at [rocq-community](https://github.com/rocq-community).

The key difference between "VSRocq 1" and `rocq-lsp` / VSRocq 2 is how
the VS Code client communicates with Rocq.

VSRocq 1 communicates with Rocq using the `coqidetop` server, which
implements an XML protocol providing basic operations on documents.

In the case of `rocq-lsp`, VSCode and Rocq communicate using the LSP
protocol, plus a set of [custom extensions](./doc/PROTOCOL.md). This
is possible thanks to a new `rocq-lsp` language server, which is an
extended Rocq binary taking advantage of improved Rocq APIs.

The XML protocol design dates back to 2012, and it is not the best fit
for modern editors. Also, the development of VSRocq 1 and `coqidetop`
was not done in tandem, which required more coordination effort.

VSRocq 1 made a significant effort to work with a vanilla XML
protocol, but that came with its own set of technical and maintenance
challenges.

A key problem in implementing a language server for Rocq is the fact
that Rocq APIs were not meant for reactive User Interfaces.

For `rocq-lsp`, we have made a years-long effort to significantly
improve Rocq's base APIs, which has resulted in a significantly lighter
client implementation and a more capable server.

Moreover, `rocq-lsp` development is active while VSRocq 1 is mostly in
maintenance mode due to the limitations outlined above. In a sense,
you could think of `rocq-lsp` as a full rewrite of VSRocq 1, using the
experience we have accumulated over years of work in related projects
(such as jsCoq, SerAPI, and Lambdapi), and the experience in
state-of-the-art UI design and implementation in other systems (Rust,
Lean, Isabelle).

We didn't pick `VSRocq 2` as a project name given that `rocq-lsp`
follows the LSP standard and is not specific to Visual Studio Code, in
fact, it works great on other editors such as vim or Emacs. The first
public release of `rocq-lsp` was on November 2022. The original
Lambdapi LSP server was written in 2017, and first ported to Rocq in
early 2019.

### VSRocq 2

[VSRocq 2](https://github.com/rocq-prover/vsrocq) follows the spirit
of `rocq-lsp` and uses an OCaml-based language server to provide an
implementation of the Language Server Protocol for the Rocq Prover.

The implementation approaches of both servers are very different.  We
are working on a more detailed comparison between the projects. The
first public release of VSRocq 2 happened in September 2023.

We encourage you to try both and provide feedback!

## Is `rocq-lsp` limited to VSCode?

No! See above!

While VSCode is for now the primary client development platform,
we fully intend the `rocq-lsp` server to be usable from other editors.

In particular, we have already ported jsCoq to work as a `rocq-lsp`
client.

Please get in touch if you would like to contribute support for your
favorite editor!

## What part of the LSP protocol does `rocq-lsp` support?

See the [PROTOCOL.md](./doc/PROTOCOL.md) file. `rocq-lsp` provides some
minimal extensions to the `rocq-lsp` protocol as to adapt to the needs
of interactive proof checking, see [this
issue](https://github.com/microsoft/language-server-protocol/issues/1414)
for more information about proof assistants and LSP.

## What is `rocq-lsp` roadmap?

The short-term roadmap is to support the full LSP protocol, and to
focus on core issues related to the needs of Rocq users.

We follow a release model based on Semantic Versioning, see our bug
tracker and project tracker for more information.

## How is `rocq-lsp` developed and funded?

`rocq-lsp` is developed collaboratively, by a [team of
contributors](https://github.com/ejgallego/rocq-lsp#team).

The development is coordinated by Emilio J. Gallego Arias, who is also
the technical lead for the project.

`rocq-lsp` was supported by Inria Paris from November 2019 to October
2024, with key contributions by Ali Caglayan (volunteer) and Shachar
Itzhaky (Technion Institute of Technology), and many other
contributors.

As of November 2024, the project is run on a volunteer basis.

## Is there more information about `rocq-lsp` design?

Yes! There are a couple of presentations related to development
methodology and internals. We will upload the presentations here
shortly. We also hope to publish a paper soon.

Our [contributing guide](../CONTRIBUTING.md) provides some valuable
information about the organization of the source code, etc...

Note that it is not easy to describe an evolving system like this, we
like this quote [from Twitter](https://twitter.com/notypes/status/1610279076320923650):

> Papers sometimes feel like a terrible way to communicate systems
> research; systems continue evolving but papers are static
>
> Our compiler (https://calyxir.org) is three years into development
> but people keep citing the paper and discussing limitations that
> have been addressed

## WebAssembly FAQ

### How can I run Rocq without installing it

You have two main alternatives:

- Head to some of the websites that offer VSCode for Web,
  such as `vscode.dev` or `github.dev`

- Download an extension artifact from our CI, and run it with:
  `npx @vscode/test-web --coi --browser chromium --extensionDevelopmentPath=.`

### What is the size of the Rocq WASM version

As of today, the Rocq WASM version requires a download of 50 - 80 MiB.
This could be improved; let us know if you are interested in
contributing.

### What is the performance of the Rocq WASM version

The Rocq WASM version performance is about an order of magnitude
slower than the native version. It is still quite usable for teaching
and other purposes.

### Can I add my own Rocq library to the WASM version?

This feature is not implemented. We currently don't have the resources
to implement it, but get in touch if you would like to help.
