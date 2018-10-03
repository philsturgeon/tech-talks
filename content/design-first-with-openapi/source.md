---
title: "Getting Specific About APIs"
theme: league
revealOptions:
  transition: 'fade'
  slideNumber: true
  autoPlayMedia: true
---

## Design-First API Specification Workflow

### Label your hecking units

API City 2018

<small>@philsturgeon</small>

---

<!-- .slide: data-background="img/build-apis-you-wont-hate.jpg" data-background-size="contain" data-background-color="#000" -->

---

<!-- .slide: data-background="img/wework.jpg" -->

<img src="img/wework-logo.jpg" style="margin-top: -30%; width:50%; ">

---

```
{
    "id": 12,
    "name": "butterfree",
    "base_experience": 178,
    "height": 11,
    "is_default": true,
    "order": 16,
    "weight": 320,
    "abilities": [{
        "is_hidden": true,
        "slot": 3
    }]
}
```

[pokeapi.co](https://pokeapi.co/)

---

<!-- .slide: data-background="img/mars-1.jpg" -->

---

<!-- .slide: data-background="img/lol1.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/lol2.jpg" data-background-size="contain" data-background-color="#000" -->

---

<!-- .slide: data-background="img/mars-article.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/mars_climate_orbiter.png" data-background-size="contain" data-background-color="#000" -->

---

> "That is so dumb," said John Logsdon, director of George Washington University's space policy institute.

---

So people write "API Reference docs"

---

<!-- .slide: data-background="img/pokeapi.png" data-background-size="contain" data-background-color="#fff" -->

---

Or you can write API specifications

_a.k.a: metadata / types / schemas / contracts_

---

### API Specs > API Docs

- Client-side validation
- Server-side validation
- Client-library Generation (SDKs)
- UI Generation
- Server/Application generation
- Mock servers
- Contract testing

---

There are a lot of "API Specification Languages" systems out there:

- API Blueprint
- HAR
- JSON Schema
- OpenAPI
- RAML 
- WSDL

---

### Chasing a Workflow

Took me a year to figure out a workflow

---

### Workflow Requirements 

1.) One single source of truth

---

### Workflow Requirements 

2.) Cannot get "out of date" 

---

### Workflow Requirements 

3.) No build step in application

---

### Workflow Requirements 

4.) Must cover "service model" and "data model"

---

<!-- .slide: data-background="img/data-model-service-model.png" data-background-size="contain" -->

---

Not a new concept, this is WSDL - from such movies as SOAP

---

<!-- .slide: data-background="img/data-model-service-model-wsdl.png" data-background-size="contain" -->

---

"REST is the new SOAP"

Hahahaha no but data / service modeling has made a comeback

---

<!-- .slide: data-background="img/unspecified-json.jpeg" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/data-model-service-model-openapi.png" data-background-size="contain" -->

---

``` yaml
openapi: 3.0.1
info:
  title: Cat on the Hat API
  version: 1.0.0
  description: The API for selling hats with pictures of cats.
servers:
  - url: "https://hats.example.com"
    description: Production server
  - url: "https://hats-staging.example.com"
    description: Staging server

... continued ...
```

---

``` yaml
paths:
  /hats:
    get:
      description: Returns all hats from the system that the user has access to
      responses:
        '200':
          description: A list of hats.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/hats'
```

---

```
components:
  schemas:
    hats:
      type: array
      items:
        $ref: "#/components/schemas/hat"

    hat:
      type: object
      properties:
        id:
          type: string
          format: uuid
        name:
          type: enum
          enum:
            - bowler
            - top
            - fedora
```

---

### OpenAPI is good at

- ✅ Documentation
- 🌦 Contract testing
- 🚫 Client-side validation
- ✅ Server-side validation
- ✅ Client-library Generation (SDKs)
- 🚫 UI Generation (E.g: HTML Forms)
- ✅ Server/Application generation
- ✅ Mock servers

---

<!-- .slide: data-background="img/human-gross.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/human-nice.png" data-background-size="contain" -->

---

### Devs Dislike Writing Docs

> How can we keep our documentation / specifications up to date?

🚫

---

### Don't Write Docs

> How can we ensure our code conforms to our contracts?

👍

---

Support API Spec-based **Contract Testing**, so planning becomes amazing tests

---

These tests are **better**, and **faster to write** than testing to confirming shapes in other ways

---

Then sprinkle in extra functionality until most devs are **excited**

---

<!-- .slide: data-background="img/openapi-workflow.jpg" data-background-size="contain" data-background-color="#fff" -->

---

### What is "Design-First"?

We all know we should plan before we code, but often we jump the gun

---

### What is "Design-First"?

Write API specs before you write any code

---

### Benefits

- get feedback from clients early

- change things until you're happy

- implement feedback without rewriting code

---

### Benefits

- upload specs to the JIRA issue for a developer to know exactly how to write their code

- bonus: code can be generated from api specs once you've locked it down

---

### Annotations 💩 

OK in "strict languages"

Awful in dynamic languages

---

``` php
/**
  * @OA\Property(
  *     default="placed",
  *     title="Order status",
  *     description="Order status",
  *     enum={"placed", "approved", "delivered"},
  *     title="Pet ID",
  * )
  *
  * @var string
  */
private $status;
```

---

Comments can get out of sync, so you **still need to contract test**

---

No time machines here!

---

## One-off Import: Traffic Sniffers

[Swagger Inspector](https://inspector.swagger.io/builder)

---

### One-off Import: Static Data

[jsonschema.net](http://jsonschema.net)

---

<!-- .slide: data-background="img/jsonschemanet.png" data-background-size="contain" data-background-color="#fff" -->

---

### One-off Import: Postman Export

Run a Postman Collection through Apimatic Transformer

_Examples will have basic schemas generated_

---

### One-off Import: Code

```
swagger generate spec -o ./swagger.json
```

---

Can still use "design first" for new functionality

---

<!-- .slide: data-background="img/openapi-workflow.jpg" data-background-size="contain" data-background-color="#fff" -->

---

## Development

![](img/openapi-workflow-waaa.png)

---

### OpenAPI GUIs

- [Stoplight.io](htpt://stoplight.io/)
- [Rapido](https://rapidodesigner.com/)

---

OpenAPI IDE/Editor Plugins

- Atom
- VS Code
- Eclipse
- JetBrains suite

---

### Lint with Speccy

![Speccy to the rescue](img/speccy.png)

---

## Continous Integration

speccy liniting to enforce advice at CI build pass/fail

---

### Contract Testing

```Feature: User API

Scenario: Show action
    When I visit "/users/1"
    Then the JSON response at "first_name" should be "Steve"
    And the JSON response at "last_name" should be "Richert"
    And the JSON response should have "username"
    And the JSON response at "username" should be a string
    And the JSON response should have "created_at"
    And the JSON response at "created_at" should be a string
    And the JSON response should have "updated_at"
    And the JSON response at "updated_at" should be a string
    .... ugh it goes on and on ...
```

---

⛔️ Contract duplication ⛔️ 

---

You _could_ validate the data against a schema using an OpenAPI data validator

But they dont really exist *

---

json schema for contract testing
    lots of json schema validators

---


---

``` ruby
require "json_matchers/rspec"

JsonMatchers.schema_root = "./schemas"
```

``` ruby
it 'should conform to hat schema' do
  get "/hats/#{subject.id}"
  expect(response).to match_json_schema('hat')
end
```
---

``` yaml
responses:
  '200':
    description: A list of hats.
    content:
      application/json:
        schema:
          # remove local reference
          # $ref: '#/components/schemas/hats'
          # Use a remote reference
          $ref: ./components/schemas/hat.json

```

---

<!-- .slide: data-background="img/json-schema-oai-differences.png" data-background-size="contain" -->

---

The most frustrating: `type: ["string", "null"]` would be invalid OpenAPI, but it is valid JSON Schema. 

---

```
$ speccy lint docs/openapi.yml
Specification schema is invalid.

#/paths/~1foo/post/requestBody/content/application~1json/properties/user_uuid
expected Array [ 'string', 'null' ] to be a string
    expected Array [ 'string', 'null' ] to have type string
        expected 'object' to be 'string'
```

---

You'd need to change it to:

```
type: string
nullable: true
```

---

Technically valid, but if a null shows up, a JSON Schema validator will report it as a mistake

---

```
$ speccy lint docs/openapi.yml --json-schema
Specification is valid, with 0 lint errors
```

Now teams can chose to use JSON Schema and OpenAPI, or _just_ OpenAPI.

---

<!-- .slide: data-background="img/data-model-service-model-openapi.png" data-background-size="contain" -->

---

### JSON Schema is good at

- 🚫 Documentation
- ✅ Client-side validation
- ✅ Server-side validation
- 🚫 Client-library Generation (SDKs)
- ✅ UI Generation
- 🚫 Server/Application generation
- 🚫 Mock servers
- ✅ Contract testing

---

Doing this gets teams to build docs whilst really just being interested in the contract testing

---

## Aggregator

```
service-a:
  name: Service Name
  description: Short blurb about the thing
  repo: “git@github.com:wework/service-name.git”
  spec_dir: api/
  entry_file: openapi.yml

service-b:
  ...
```

---

```
$ speccy resolve api/openapi.yml --json-schema
```

---

```
[
  {
    "name": "Service A",
    "slug": "service-a",
    "contact": {
      "team": "Some Team",
      "email": "some-team@example.com"
    },
    "openapi_url": "http://apis.example.com/specs/service-a/openapi",
    "postman_url": "http://apis.example.com/specs/service-a/postman-collection",
    "mock_server_url": "http://apis.example.com/mocks/service-name/"
  },
  {
    ...
  }
]
```

---

Now things can read this list of APIs and build things! 

---

### Mock Server

- [Prism](https://github.com/stoplightio/prism) (v3 Coming Soon™)
- [API Sprout]()

---

### Hosted Mock Servers

- [stoplight.io](https://stoplight.io/)
- [restpoint.io](http://restpoint.io)
- [getsandbox.com](http://getsandbox.com)
- Postman Mock Server

---

### SDK Geneerator

---

### Postman Collections

Postman Collections via Apimatic Transformer

Postman GUI will have updated to contain any new endpoints, improved examples, etc.

---

### Documentation

passes each openapi_url through ReDoc. The static HTML is put in the public/ folder along with all our other technical documentation, and job done.

---

### E2E Acceptance Testing

similar in functionality to [Stoplight: Scenarios](https://stoplight.io/platform/scenarios/

https://www.frisbyjs.com/

---

RSpec + Faraday + an OpenAPI Validation Service

AJV based

---

TODI diagram of 


---


## Further Possibilities


Make JSON Schema files available via `Link` headers for clients to use! 

```
Link: <http://example.com/schemas/v1.0.0/user.json#>; rel=”describedby”
```

--- 

JSON Schema validators

---

JSON Schema UI 

---

JSON HyperSchema for HATEOAS in your API

---

Stoplight can do a _lot_ of this

---

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">We 💖 hearing about different teams API workflows and how they are built on top of specifications. Here&#39;s a great example of that from the WeWork Technology team written by <a href="https://twitter.com/philsturgeon?ref_src=twsrc%5Etfw">@philsturgeon</a>: <a href="https://t.co/3YsGglBhpQ">https://t.co/3YsGglBhpQ</a> <a href="https://t.co/k6DHju0Xvp">pic.twitter.com/k6DHju0Xvp</a></p>&mdash; Stoplight (@stoplightio) <a href="https://twitter.com/stoplightio/status/1037399476237991938?ref_src=twsrc%5Etfw">September 5, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

---

<!-- .slide: data-background="img/book.jpg" data-background-size="contain" -->

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<small><strong><a href="https://apisyouwonthate.com">apisyouwonthate.com</a></strong></small>
