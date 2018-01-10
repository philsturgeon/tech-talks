---
title: "HTTP Caching: It's Easy & Saves the Polar Bears"
theme: beige
---

# HTTP Caching

## It's Easy & Saves the Polar Bears

### PHPSW (BRIZZLE!) / @philsturgeon

---

## GraphQL is optimized for network speed

But ignores HATEOAS and most of HTTP, like **caching**

---

## REST is optimized for API longevity

Network performance is a lesser concern

---

<!-- .slide: data-background="img/shrink-graphql.png" data-background-size="contain" data-background-color="#F5F6F8" -->

---

# Sparse Fieldsets

`GET /turtles/123?fields=name,lifespan,avg_weight`

---

# Partials

`GET /turtles/123?partials=dimensions`

---

Making unnecessary requests "quicker" is **not** clever

---

<!-- .slide: data-background="img/cache-rest.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/richardson.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/richardson-not-rest.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/richardson-rest.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/hypermedia-like-no-handlebars.jpg" data-background-size="contain" data-background-color="#000"-->

---

## Client Caching

A GraphQL Client is entirely responsible for:

- Cache duration
- Cache invalidation

---

Each client has to guess the rules for how long to cache certain data, and how to invalidate

---

REST says this should be a concern of the server

---

Endpoint-based APIs can utilize all of HTTP Caching:

- `Expires`
- `Cache-Control`
- `ETag`
- `If-Modified-Since`
- `Varies`

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

46% speedup by sharing that cache

---

Enable [faraday-http-cache](https://github.com/plataformatec/faraday-http-cache) to magically respect cache headers

---

## Compromise

Use [partials](https://blog.apisyouwonthate.com/a-happy-compromise-between-customization-and-cacheability-e48dc083ed10) as a middleground

```
GET /turtles?partial=dimensions
```

<small>is.gd/api_partials</small>

---

GrahQL cannot use existing HTTP network caching tools

---

## Data has to be readily accessable for ANY query

That's not something you should take lightly

---

_You won't have an efficient GraphQL API without restructing your data_

---

GitHub, Facebook, etc. have a few more resources than the rest of us

---

## JSON-API-style **mega-includes** same

GET /me?include=literally,everything,in,
the,goddam,database,what,is,
happening,so,slow,help,me,database,
server,is,on,fire,agggghhhhhh

---

## Multiple handshakes are not going to be _your_ bottleneck

_And HTTP/2 solves the multiple handshake issue anyway_

---

## REST vs RESTish

---

Most RESTish APIs miss the most important concept: Controls

---

<!-- .slide: data-background="img/hypermedia-like-no-handlebars.jpg" data-background-size="contain" data-background-color="#000"-->

---

<!-- .slide: data-background="img/richardson.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/richardson-not-rest.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/richardson-rest.png" data-background-size="contain" data-background-color="#fff" -->

---

Hypermedia controls are seen as confusing, slow or pointless

---

### BECAUSE THEY ARE MISUSED + MISUNDERSTOOD

---

## REST != CRUD over HTTP

---

Hypermedia "Links" are not just for related data

---

## REST == State Machines over HTTP

```ruby
class InvoiceStateMachine
  include Statesman::Machine

  state :draft, initial: true
  state :published
  state :sent
  state :paid

  transition from: :draft,        to: :published
  transition from: :published,    to: [:draft, :sent, :paid]
  transition from: :sent,         to: :paid

  # next slide
end
```

---

```ruby
  guard_transition(to: :sent) do |invoice|
    invoice.has_contact_info?
  end

  before_transition(to: :sent) do |invoice, transition|
    EmailService.new(invoice).send_contact_invoice
  end

  after_transition(to: :paid) do |invoice, transition|
    EmailService.new(invoice).send_owner_success
  end
```

---

## Simple State machines

``` ruby
invoice.current_state # => "draft"
invoice.allowed_transitions # => ["pay"]
invoice.transition_to(:paid) # => true/false
```

---

## State Machines can power Hypermedia Controls!

Original approach...

```
{
  "data": {
    "type": "invoice",
    "id": "093b941d",
    "attributes": {
      "bla": "stuff",
      "status": "draft"
    }
  },
  "links": {
    "pay": "https://api.acme.com/invoices/093b941d/payment_attempts"
  }
}
```

---

# Different levels of HATEOAS

---

## 1.) String containing just URL

```
"links": {
  "pay": "https://api.acme.com/invoices/093b941d/payment_attempts"
}
```

- If link exists clients can "click it"
- (No guarentee of success)
- Make URL respond to `OPTIONS`
- Use `Allow: GET, PATCH` to show available actions

---

**Downsides**

1. Working out what GET and PATCH are exactly for
2. What fields should be sent to PATCH

---

## 2.) Add metadata to that OPTIONS payload

- Use JSON Schema to detail fields
- Use JSON HyperSchema to detail potential actions
- Entirely optional extra layer of strictness

---

**Downsides**

Optional nature means some clients will ignore/not notice

---

## 3.) Add Hypermedia controlls in response

```
  "actions": [
    {
      "name": "add-item",
      "title": "Add Item",
      "method": "POST",
      "href": "http://api.x.io/orders/42/items",
      "type": "application/x-www-form-urlencoded",
      "fields": [
        { "name": "orderNumber", "type": "hidden", "value": "42" },
        { "name": "productCode", "type": "text" },
        { "name": "quantity", "type": "number" }
      ]
    }
  ],
```

[Siren](https://github.com/kevinswiber/siren) / [HAL](https://tools.ietf.org/html/draft-kelly-json-hal-06)

_[Many others](https://sookocheff.com/post/api/on-choosing-a-hypermedia-format/)_

---

**Downsides**

Increases size of response message

---

### HATEOAS Pitch

HATEOAS can help clients build "Actions" dropdowns dynamically!

![](img/dynamic-actions.png)

---

### HATEOAS Pitch

GraphQL cannot help you communicate with other systems

---

### HATEOAS Pitch

Hypermedia can help you make cross-API requests

---

### HATEOAS Pitch

iOS, Web and XBox apps _cannot_ mismatch state

Note: One client offers link another doesnt

---

## Enough, we dont want/need HATEOAS

---

GraphQL is a great alternative to JSON-API-like RESTish APIs

---

## GraphQL makes Deprecations awesome

```
POST /graphql HTTP/1.1
Content-Type: application/graphql

{
  turtles(id: "123") {
    length,
    width,
    intelligence
  }
}
```

---

```
type Turtle {
  length: String
  width: Int
  intelligence: String @deprecated
}

---

Endpoint-based APIs can deprecate whole endpoints

`Sunset: Thu, 13 Jul 2017 15:42:12 GMT`

([IETF Draft](https://tools.ietf.org/html/draft-wilde-sunset-header-03))

---

[faraday-sunset](https://github.com/philsturgeon/faraday-sunset)

---

> DEPRECATION WARNING: Endpoint #{env.url} is deprecated for removal on #{datetime.iso8601}

---

If you don't want to learn:

- Serializing data
- Implement sparse fieldsets
- GZiping contents
- Outlining data structures with JSON Schema
- Offer binary alts to JSON like Protobuff or CapnProto
- Evolution instead of global versioning

---

### The maybe just use GraphQL

---

It's packaged together in one system, which is cool

---

### Ask yourself

Are you ok letting go of HTTP?

---

### Ask yourself
How different are your clients from each other?

---

### Ask yourself
Do you trust your clients to handle caching without any hints from the server?

---

### Ask yourself
Do you trust your clients to handle caching without any hints from the server?

---

### Ask yourself
Do we _defitely_ never _ever_ want HATEOAS?

---

## I would use GraphQL for

A highly query-able API, with wide array of clients that need small and different data, and data is inexpensive to query...

---

## I would use GraphQL for

A [mostly] read-only Statistics API

---

## I would use GraphQL for

A CRUD API that 100% did not need HATEOAS or file uploads ever

---

## I would use GraphQL for

A CRUD API that the team might make shitty

---

# Thanks!

Slides are up on [philsturgeon.uk/speaking](http://philsturgeon.uk/speaking)

Go to [blog.apisyouwonthate.com](http://blog.apisyouwonthate.com) for more APIs
