These days type systems are all the rage in APIs, and with gRPC and GraphQL fans touting their baked in systems. REST fans have a few options for type systems, but JSON Schema and OpenAPI seem to be powering forwards as the primary candidates for not only documenting APIs but a whole lot more.

JSON Schema is metadata for JSON, which can be used for a whole bunch of things. We’ve written about how JSON Schema can really simplify contract testing, how JSON Schema can add non-invasive hypermedia controls to existing APIs, and - seeing as JSON Schema is mostly compatible with OpenAPI - it can be used to generate meaningful and beautiful human-readable documentation too!

We’re going to look at how you can design the initial specs with beautiful editors (or generate from other sources if they already exist), then use those specs for a myriad of amazing things, from human docs to SDK generation, automated Postman Collection syncing, to alerting folks about changes, and a lot more.



Introduce JSON Schema
Introduce OpenAPI

img service model all openapi
img service model openapi + json

example of endpoints described
example of a schema

 API Specifications are not just about docs
    - show redoc
    - mocking
    - sdk generation
    - api console 
    - client-side validation
    - server-side validation
    - contract testing

hard part: one single source of truth
    dont wanna have to maintain your contract in multiple places
    dont want things getting out of sync

hard enough getting devs to "write docs", making them maintain an api console _and_ validation rules... no

carrots instead of sticks

    - devs hear "you should write docs because ultuism:"
    - then devs struggle to keep docs up to date   
    - offer enough useful functionality that devs _want_ to write specs
    - make all of these features so easy it enables devs instead of slows them down
    - bake contract testing into the pipeline so they're keeping their code in line with specs, not specs in line with code

Show the workflow

what does design first mean
    - write api specs before you write any code
    - get feedback from clients early
    - change things until you're happy
    - implement feedback without rewriting code
    - bonus: code can be generated from api specs once you've locked it down

why annotations generally suck
    - annotations are shitty for most dynamic langs
    - comments can get out of sync, so you still need to contract test
    - you need more than just data type, you can provide validation and all sorts of maxLength etc, why write all that in comments

ok but no time machine
you probably already have APIs, so you want to get them on this workflow
    - importing from various sources
    - maybe pull the specs from code
    - can still use "design first" for 

workflow

## Development

workflow waaa

OpenAPI GUIs
    - stoplight
    - [Rapido](https://rapidodesigner.com/)

OpenAPI IDE/Editor Plugins

    Atom
    VS Code
    Eclipse
    JetBrains suite

speccy linting to give you feedback 
    speccy screenshot

## Continous Integration

speccy liniting to enforce advice at CI build pass/fail

Contract Testing

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

⛔️ Contract duplication ⛔️ 

You _could_ validate the data against a schema using an OpenAPI data validator

But they dont really exist *

json schema for contract testing
    lots of json schema validators

```
  responses:
    200:
      description: OK
      content:
        application/json:
          schema:
            # This file is JSON Schema... buuut..
            $ref: ./components/schemas/user.json
```

ok side note disrepencies
    caveats.png

The most frustrating: `type: ["string", "null"]` would be invalid OpenAPI, but it is valid JSON Schema. 

```
$ speccy lint docs/openapi.yml
Specification schema is invalid.

#/paths/~1foo/post/requestBody/content/application~1json/properties/user_uuid
expected Array [ 'string', 'null' ] to be a string
    expected Array [ 'string', 'null' ] to have type string
        expected 'object' to be 'string'
```

You'd need to change it to:

```
type: string
nullable: true
```

Technically valid, but if a null shows up, a JSON Schema validator will report it as a mistake

```
$ speccy lint docs/openapi.yml --json-schema
Specification is valid, with 0 lint errors
```

Now teams can chose to use JSON Schema and OpenAPI, or _just_ OpenAPI.

Doing this gets teams to build docs whilst really just being interested in the contract testing


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

```
$ speccy resolve api/openapi.yml --json-schema
```

```
[
  {
    "name": "Service A",
    "slug": "service-a",
    "contact": {
      "team": "Some Team",
      "email": "some-team@example.com"
    },
    "openapi_url": "http://apis.exampkle.com/specs/service-a/openapi",
    "postman_url": "http://apis.exampkle.com/specs/service-a/postman-collection",
    "mock_server_url": "http://apis.exampkle.com/mocks/service-name/"
  },
  {
    ...
  }
]
```



## Further Possibilities


Make JSON Schema files available via `Link` headers for clients to use! 



Having both means you can use JSON Schema for everything its good at:

    JSON Schema validators
    JSON Schema UI 
    JSON HyperSchema for HATEOAS in your API



Stoplight can do a _lot_ of this

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">We 💖 hearing about different teams API workflows and how they are built on top of specifications. Here&#39;s a great example of that from the WeWork Technology team written by <a href="https://twitter.com/philsturgeon?ref_src=twsrc%5Etfw">@philsturgeon</a>: <a href="https://t.co/3YsGglBhpQ">https://t.co/3YsGglBhpQ</a> <a href="https://t.co/k6DHju0Xvp">pic.twitter.com/k6DHju0Xvp</a></p>&mdash; Stoplight (@stoplightio) <a href="https://twitter.com/stoplightio/status/1037399476237991938?ref_src=twsrc%5Etfw">September 5, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
