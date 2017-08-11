---
title: A No Nonsense GraphQL and REST Comparison
theme: beige
---

# A No Nonsense GraphQL and REST Comparison

### NEPHP 2017 / @philsturgeon

---

1. REST and GraphQL are totally different

2. GraphQL isn't a magic bullet, nor is it "better"

3. You can definitely use both at the same time

4. GraphQL is dope if used for the right thing

---

<!-- .slide: data-background="img/different-shapes-siezed.jpg" -->

---

<!-- .slide: data-background="img/penny-farthing.jpg" -->

---

<!-- .slide: data-background="img/random-bike.jpg" -->

---

<!-- .slide: data-background="img/random-bike-use-cases.jpg" data-background-size="contain" -->

---

<!-- .slide: data-background="img/random-bike-hacks.png" data-background-size="contain" -->

---

<!-- .slide: data-background="img/many-bikes.jpg" data-background-size="contain" -->

---

<!-- .slide: data-background="img/random-bike-issues.jpg" data-background-size="contain" -->

---

## Pro-GraphQL
## Pro-REST
## Pro-RPC

---

## Anti-Nonsense

Note: I have recommended RPC, REST _and_ GraphQL for different services at WeWork in the last few months.

---

# "GraphQL is REST 2.0"

---

<!-- .slide: data-background="img/nonsense.jpg" -->

---

<iframe width="924" height="520" src="https://www.youtube.com/embed/9wiepxb8qPc" frameborder="0" allowfullscreen></iframe>

---

<!-- .slide: data-background="img/random-bikes-obviously-misused.jpg" data-background-size="contain" -->

---


## Time Wasting

Rebuilding stuff for one thing, which you could have in REST is wasteful

---

## Brain Washing

Switching just becauase hype or cool is a drug you gotta quit

---

GraphQL is a newer concept, being released by Facebook publicly in 2015.

---

REST was a dissertation published by Roy Fielding in 2000, popularized kinda by companies like Twitter in 2006.

---

<!-- .slide: data-background="img/graphql-org.png" -->

---

<!-- .slide: data-background="img/rest-disert.png" -->

---

Easy to see why some folks think one is a replacement

---


REST is an architectural concept for network-based software, has no official set of tools, has no specification, doesn't care if you use HTTP, AMQP, etc., and is designed to decouple an API from the client. The focus is on making APIs last for decades, instead of optimizing for performance.


---


GraphQL is a query language, specification, and collection of tools, designed to operate over a single endpoint via HTTP, optimizing for performance and flexibility.


---

One of the main tenants of REST is to utilize the uniform interface of the protocols it exists in. When utilizing HTTP, REST can leverage HTTP content-types, caching, status codes, etc., whereas GraphQL invents its own conventions.

---

<!-- .slide: data-background="img/rest-can-do-that-1.png" data-background-size="contain" data-background-color="#F5F6F8" -->

---

# REST Allows That



---

<!-- .slide: data-background="img/rest-can-do-that-2.png" data-background-size="contain" data-background-color="#F5F6F8" -->

---

# REST Allows That
TODO slide about doing this in REST

---

<!-- .slide: data-background="img/rest-can-do-that-3.png" data-background-size="contain" data-background-color="#E6E8EC" -->

---

# REST Allows That
TODO slide about doing this in REST

---

<!-- .slide: data-background="img/rest-can-do-that-4.gif" data-background-size="contain" data-background-color="#E6E8EC" -->

---

# REST Begs You To Do That!
TODO slide about doing this in REST

---





Query Languages



## Remember FQL?

```
GET /fql?q=SELECT uid FROM friend WHERE uid=me()&access_token=...
```

---

Facebook didn't like FQL _and_ RESTish so they combined it

Note: Most of us would never even consider using FQL

---

## Client Caching

A GraphQL Client is entirely responsible for:

- Cache duration
- Cache invalidation

---

## Client Caching

HTTP APIs can utilize all of HTTP:

`Expires, Cache-Control, ETag, If-Modified-Since, Varies`

---

## Network Caching

HTTP has loads of amazing caching proxies

---

![](img/caching.png)

---

## Customization = Cache Misses

**Client A**

`GET /turtles?fields=name,lifespan`

200ms

**Client B**

`GET /turtles?fields=name`

200ms

---

## Customization = Cache Misses

**Client A**

`GET /turtles`

220ms

**Client B**

`GET /turtles`

118ms

---

## Customization = Cache Misses

GrahQL cannot use HTTP network caching

---

## REST vs RESTish

---

<!-- .slide: data-background="img/richardson.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/hypermedia-like-no-handlebars.jpg" data-background-size="contain" data-background-color="#000" -->

---

RESTish &amp; GraphQL are both about Tight Coupling

---

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">If you control both sides of the wire (client and server) and can deploy simultaneously, most of REST&#39;s constraints are unnecessary work.</p>&mdash; Darrel Miller (@darrel_miller) <a href="https://twitter.com/darrel_miller/status/894638898512621572">August 7, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

---


Lose Coupling &amp; Evolution

<img src="img/crash-but-recover.gif">


---


Lose Coupling &amp; Evolution

<img src="img/crash-but-recover-2.gif">

---


Tight Coupling...

<img src="img/crash-unrecoverable.gif">

Note: Need a LOT of developers
Amazing docs + automated testing

---

HATEOAS helps avoid tight Coupling

---

How to HATEOAS

1. Just links (they figure it from Allows: GET, PATCH)
2. add more meta data to OPTIONS so they figure from that
3. add controlls in response (Siren) to avoid figuring

---

GraphQL cannot help you communicate with other systems, HATEOAS ca

---

Packaged together in one system, which is cool

---

### Ask yourself

Are you ok letting go of HTTP?

How different are your clients from each other?

Do you trust your clients to handle caching?

Quick to build and easy to break?

Slow to build and more resiliant?

Just data, or file upload/download too?
