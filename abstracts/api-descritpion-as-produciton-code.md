---
title: API Descriptions as Production Code
slides:
category: api
tags: api specs, api descriptions, api design, validation
---

API Description Documents (a.k.a "specifications") can be used for all sorts of
time and money saving things. At this point most developers are aware they can
help with docs and have maybe played around with mocking, but they often have this
concern about "keeping specs in sync with code".

This talk walks through using API description documents for client-side
validation (avoid validation hell by telling your clients how they should handle
validation), server-side validation in the application (stop writing complex
validation logic in your ORM model or some other awkward place), and validation
in the API gateway (don't even bother wasting application server resources with
invalid requests).

Mostly talking about OpenAPI and JSON Schema, as they can do a whole lot more than
Protobuf and GraphQL Types.