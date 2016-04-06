---
title: What Rails Can Teach PHP About Building APIs
slides:
category: api
tags: rails, api, php
---

As somebody who's built APIs with PHP since 2009, and built APIs with Rails for the last two years, the contrast in some of the tooling available is mind-blowing. When it comes to factories for generating test data, spec-driven testing with tools like RSpec, mutation testing, simplistic state machines, serialization and deserialization in JSON-API, REPL debugging with breakpoints, file upload handlers, etc., Ruby (and Rails) very often has a strong lead in maturity of the tooling.

PHP does have a few of these tools, but due to years of fractured development as people build framework-specific alternatives, they are not as mature as they could be. Other tools are just entirely missing in PHP land. Now that PHP has got past building framework-specific SF Bundles, Laravel Bundles, CI Sparks, ZF2 Modules, etc, and is moving to Composer-based framework agnostic code, these tools are starting to crop up and mature.

While PHP is learning how to work together on powerful, agnostic, shared code, let's look at some of the tooling available in Ruby, to see what inspiration we can draw from their experiences. There is a lot of great Ruby code built for developing and testing APIs, which PHP-land can learn a lot from!
