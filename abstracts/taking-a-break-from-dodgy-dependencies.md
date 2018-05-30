---
title: Taking A Break From Dodgy Dependencies
slides:
category: api
tags: api, architecture, ruby, http, timeouts, circuit breakers
---

Too often we write code that makes network calls, and we hope everything will work just fine. "Occasional errors might happen, but not very often, so let's not worry about it!" we say to ourselves. That's all well and good until the entire architecture goes up like a bonfire, because service A called B which called C, C is slow right now because D is having a bad day, and on top of that, D is actually calling C sometimes, so they both crash each other every time one of them starts to have a bit of a problem.

Learn about limiting the problem by using timeouts on HTTP requests, especially those in the web thread. 😨

Then we'll look at increasing our chances of success with retries, and learn about using circuit breakers to know when to not even bother waiting to attempt a call to a system that's already capsized.
