---
title: "HTTP Caching: It's Easy & Saves the Polar Bears"
theme: sky
---

# HTTP Caching

## Stop Melting The Ice Caps

### PHP South West / @philsturgeon

---

Stuff like GraphQL optimizes for _network speed_

---

i.e: Each interaction must be the quickest possible

---

<!-- .slide: data-background="img/shrink-graphql.png" data-background-size="contain" data-background-color="#F5F6F8" -->

---

This only really helps if any of those fields are _computed_

_(Don't compute read data on-the-fly!!)_

---

_Trimming_ a resource is usually not as useful as _reusing_ a resource

---

REST optimizes for _network efficiency_ over _network speed_

---

### Efficiency > Speed

Making unnecessary requests "quicker" is **not** efficient (or clever)

---

<!-- .slide: data-background="img/rest-disert.png" data-background-size="contain" data-background-color="#F5F6F8" -->

---

<!-- .slide: data-background="img/cache-rest.png" data-background-size="contain" data-background-color="#F5F6F8" -->

---

<!-- .slide: data-background="img/richardson-cache.png" data-background-size="contain" data-background-color="#F5F6F8" -->

---

> Um, like, REST didn't invent caching, we already cache our responses in Redis!

---

## Naive Client Caching

```
Rails.cache.fetch("users/#{uuid}", expires_in: 12.hours.from_now) do
  UserAPI.find_user(uuid)
end
```

---

## Expiry Guessing
### Problem 1

12 is an arbitrary number plucked out my... brain

---

## Expiry Changing
### Problem 2

12 might be a good idea now, but might not be next month

---

## Invalidations
### Problem 3

Your client has to subscribe to AMQP/WebSockets/something to invalidate

---

REST says these problems should be a concern of the **server**

---

Endpoint-based APIs can utilize all of [RFC 7234](https://tools.ietf.org/html/rfc7234)

- `Expires`
- `Cache-Control`
- `ETag`
- `If-Modified-Since`
- `Varies`
- _and more!_

---

## <strike>Expiry Guessing</strike>

```
Cache-Control: public, max-age=28800
```

---

## <strike>Expiry Changing</strike>

```
Cache-Control: public, max-age=25200
```

---

Pur

---

## <strike>Invalidations</strike>

```
Cache-Control: public, max-age=25200
ETag: some-opaque-string-abc
```

...

```
GET /turtles/123
If-Match: some-opaque-string-abc
```

↓

```
HTTP/1.1 304 Not Modified
```

---

Not Modified means "Use the response you already have"

---

Server doesn't need to serialize JSON

---

``` ruby
class TurtlesController < BaseController
  def show
    turtle = ...

    expires_in(15.minutes, public: true)
    if stale?(turtle)
      render json: serialize(turtle)
    end
  end
end
```

---

Client doesn't have to wait for that JSON to download

---

<!-- .slide: data-background="img/content-download.png" data-background-size="contain" data-background-color="#F5F6F8" -->

---

### Customization vs Caching

`GET /turtles/123?fields=name,lifespan`

---

`/turtles/123?fields=name,lifespan,weight`

≠

`/turtles/123?fields=name,weight,lifespan`

---

Why even bother?!

---

**Client A**

`GET /turtles?fields=name,lifespan`

200ms

---

**Client B**

`GET /turtles?fields=name`

192ms

---

%4 speedup by missing the cache to skip one field

---

**Client A**

`GET /turtles`

220ms

---

**Client B**

`GET /turtles`

118ms

---

10% slow down requesting all the things

_buuuut_

46% speedup by hitting that shared cache

---

## Compromise

Use [partials](https://blog.apisyouwonthate.com/a-happy-compromise-between-customization-and-cacheability-e48dc083ed10) as a middleground

```
GET /turtles?partial=dimensions
```

<small>is.gd/api_partials</small>

---

# MIDDLEWARES

Let somebody else do literally all the work and implement RFC 7234 for you.

---

## Ruby/Rails

```
client = Faraday.new do |builder|
  builder.use :http_cache, store: Rails.cache
  ...
end
```

[faraday-http-cache](https://github.com/plataformatec/faraday-http-cache)

---

## PHP

```
use GuzzleHttp\Client;
use GuzzleHttp\HandlerStack;
use Kevinrob\GuzzleCache\CacheMiddleware;

$stack = HandlerStack::create();
$stack->push(new CacheMiddleware(), 'cache');
$client = new Client(['handler' => $stack]);
```

[guzzle-cache-middleware](https://github.com/Kevinrob/guzzle-cache-middleware)

---


BUT I STIL HAVE TO INVALIDATE BC SOME REQUESTS...

Request cache control

https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control

---


# Different Strategies

1. Check resource `Expires` or `Cache-Control` headers and set expiry in cache
1. Store the headers in the cache
1. Redis/Memcache will expire entry once it is not "fresh"
1. If no fresh

---

Every client has its own cache bluuugh diagram

---

## Network Caching

HTTP has loads of amazing caching proxies:

- Vanish
- Squid
- Fastly
- Nginx!

---

![](img/caching.png)

---

## HTTP/1.1 Network Hacks

Network hacks made us forget about cacheability

---

GraphQL cannot use existing HTTP network caching tools

---

## Multiple handshakes are not going to be _your_ bottleneck

_And HTTP/2 solves the multiple handshake issue anyway_

---

# Thanks!

Slides are up on [philsturgeon.uk/speaking](http://philsturgeon.uk/speaking)

Go to [blog.apisyouwonthate.com](http://blog.apisyouwonthate.com) for more APIs
