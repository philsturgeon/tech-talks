---
title: Design-first Workflow with OpenAPI v3.0 & JSON Schema
slides:
category: api
tags: api, architecture, ruby, http, timeouts, circuit breakers
elevator: |>
  Over the last year, the API specification world has gone from a myriad of awkward hacks from competing incompatible specifications in the midst of change, to two amazing complimentary specifications: OpenAPI and JSON Schema. Learn how to do so much more than document an API with these tools.
---

These days type systems are all the rage in APIs, and with gRPC and GraphQL fans touting their baked in systems. REST fans have a few options for type systems, but JSON Schema and OpenAPI seem to be powering forwards as the primary candidates for not only documenting APIs but a whole lot more.

JSON Schema is metadata for JSON, which can be used for a whole bunch of things. We’ve written about how JSON Schema can really simplify contract testing, how JSON Schema can add non-invasive hypermedia controls to existing APIs, and - seeing as JSON Schema is mostly compatible with OpenAPI - it can be used to generate meaningful and beautiful human-readable documentation too!

We’re going to look at how you can design the initial specs with beautiful editors (or generate from other sources if they already exist), then use those specs for a myriad of amazing things, from human docs to SDK generation, automated Postman Collection syncing, to alerting folks about changes, and a lot more.
