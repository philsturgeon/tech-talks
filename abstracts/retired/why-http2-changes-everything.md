---
title: Why HTTP/2 Changes Everything
slides:
category: http
tags: api design, http, http2
---

Whilst the majority of the HTTP community seem to be arguing about the best way
to batch queries and solve HTTP/1.1 problems, HTTP/2 is old enough to walk,
talk, and pedal a tricycle. HTTP/3 is coming too and why are we all still
bending over backwards with application-level nonsense trying to make APIs
performant over HTTP/1.1. 🤦‍♀️

HTTP/2 changes how we think about API development in pretty much every way.
Clients no longer have to worry about "max connections" thanks to multiplexing,
the same connection is maintained so "multiple handshakes" are out the window,
Server Push can start sending likely requests before you even ask for them
Push-Please let you configure what gets sent, HPACK compresses headers by
default so maybe you don't need to trim a few fields off the resource to save
bits, and we can finally actually use HATEOAS without worrying about "extra
calls".

Once this new approach takes root in your API, you can start designing smaller
more targeted resources, instead of all your resources containing every
tangentially related thing ever. This means you can use more HTTP caching, as
suddenly a Foo changing doesn't mean a Bar is now invalidated.

Every language and framework worth its salt supports either all of this, or most of it,
and if it doesn't, you cn change!

Unless you're using GraphQL, then you can't do most of this. Sorry. 🤷‍♂️