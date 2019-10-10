---
title: "API Descriptions as Production Code"
theme: league
revealOptions:
  transition: 'fade'
  controls: false
  progress: false
---

<!-- .slide: data-background="img/bg.jpeg" -->

<br>
<br>
<br>
<span style="font-size: 60pt; color: black">API Descriptions as Production Code</span>

---

<!-- .slide: data-background="img/trip.jpg" -->

---

<!-- .slide: data-background="img/offset-earth.png" -->

---

<!-- .slide: data-background="img/dino.png" data-background-size="contain" -->

---

## 2018 Questions

1. Design First or Code First? 
1. What tooling supports OpenAPI v3.0? <!-- .element: class="fragment" -->
1. Why are there no editors? <!-- .element: class="fragment" -->
1. How/when do we create documentation? <!-- .element: class="fragment" -->
1. How/when do we create mocks?  <!-- .element: class="fragment" -->
1. How can we enforce style guides for docs?  <!-- .element: class="fragment" -->
1. How do we keep code and docs in sync?  <!-- .element: class="fragment" -->

---

<!-- .slide: data-background="img/workflow.jpeg" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/workflow2.jpeg" data-background-size="contain" data-background-color="#fff" -->

---

<img src="img/logo.dark.png" style="border:0; background:transparent;box-shadow:0">

---

**What tooling supports OpenAPI v3.0?**

most of it <!-- .element: class="fragment" -->

https://openapi.tools <!-- .element: class="fragment" -->

---

<!-- .slide: data-background="img/tools.png" data-background-size="contain" -->

---

**Design First or Code First?**

---

```java
class UserController {
  @OpenApi(
      path = "/users",
      method = HttpMethod.POST,
      // ...
  )
  public static void createUser(Context ctx) {
      // ...
  }
}
```

---

```php
/**
  * @OA\Get(path="/2.0/users/{username}",
  *   operationId="getUserByName",
  *   @OA\Parameter(name="username",
  *     in="path",
  *     required=true,
  *     description=Explaining all about the username parameter
  *     @OA\Schema(type="string")
  *   ),
  *   @OA\Response(response="200",
  *     description="The User",
  *     @OA\JsonContent(ref="#/components/schemas/user"),
  *     @OA\Link(link="userRepositories", ref="#/components/links/UserRepositories")
  *   )
  * )
  */
public function getUserByName($username, $newparam)
{
}
```

---

> Code comments are just facts waiting to become lies.

_<small>Vinai Kopp, A talk at #MM18IT</small>_

---

<!-- .slide: data-background="img/code-comments.jpg" data-background-size="contain" -->

---

<!-- .slide: data-background="img/wf-1.png" data-background-size="contain" data-background-color="#eee" -->

---

<!-- .slide: data-background="img/wf-2.png" data-background-size="contain" data-background-color="#eee" -->

---

<!-- .slide: data-background="img/wf-3.png" data-background-size="contain" data-background-color="#eee" -->

---

<!-- .slide: data-background="img/wf-4.png" data-background-size="contain" data-background-color="#eee" -->

---

<!-- .slide: data-background="img/lifecycle.png" data-background-size="contain" data-background-color="#eee" -->

---

> While OpenAPI is great for describing APIs, ... **it's definitely not a great experience to write OpenAPI documents from scratch**.

_<small>Sebastien Armand, "Making OpenAPI Bearable With Your Own DSL"</small>_

---

**Why are there no editors?**

https://stoplight.io/studio <!-- .element: class="fragment" -->

---

<!-- .slide: data-background="img/studio.png" data-background-size="contain" data-background-color="#000" -->

<!-- TODO Add file system image -->

---

<!-- .slide: data-background="img/studio-adv.png" data-background-size="contain" data-background-color="#000" -->

---

<!-- .slide: data-background="img/studio-md.png" data-background-size="contain" data-background-color="#fff" -->

---

**How/when do we create documentation?**

https://stoplight.io/docs <!-- .element: class="fragment" -->

---

<!-- .slide: data-background="img/docs.png" data-background-size="contain" data-background-color="#fff" -->

---

**How/when do we create mocks?**

Studio has a mock server built right in 🙌 <!-- .element: class="fragment" -->

Hosted Mock Server coming soon... ⏳ <!-- .element: class="fragment" -->

---

⛔️ **How do we keep code and API docs in sync?**

---

- ⛔ Documentation
- ⛔ API Specifications <!-- .element: class="fragment" -->
- ✅ API Description Documents <!-- .element: class="fragment" -->

---

✅ **How to use API descriptions as code!**

---

Code Generation is another talk... 

---

<!-- .slide: data-background="img/docs-api.jpg" data-background-size="contain" data-background-color="#fff" -->

---

## Server-side Validation

- Model?
- Controller? <!-- .element: class="fragment" -->
- View? 😱 <!-- .element: class="fragment" -->
- Service? <!-- .element: class="fragment" -->
- Contract? <!-- .element: class="fragment" -->

---

## Server-side Ruby Validation

``` ruby
class NewUserContract < Dry::Validation::Contract
  params do
    required(:email).filled(:string)
    required(:age).value(:integer)
  end

  rule(:email) do
    unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
      key.failure('has invalid format')
    end
  end

  rule(:age) do
    key.failure('must be greater than 18') if value < 18
  end
end
```

---

## Server-side JavaScript Validation

```js
import Joi from 'joi';

export default {
  createUser: {
    body: {
      username: Joi.string().regex(/^[0-9a-fA-F]{24}$/).required(),
      email: Joi.string().required(),
      age: Joi.number()
    }
  }
};
```

Note: Most JS examples are so gross they dont fit on screen

---

## Looks like an API Description

``` yaml
type: object
properties:
  username: 
    type: string
  email: 
    type: string
    format: email
  age: 
    type: integer
    minimum: 18
required:
- email
- age
```

---

Multiple Sources Of Truth = Checking For LIES

---

Dredd, takes a lot of work and breaks so much teams just turn it off

https://dredd.org/

---

## Reuse API Descriptions for Validation

No need to write any code

```ruby
# config/application.rb

config.middleware.use Committee::Middleware::RequestValidation,
  schema_path: 'openapi.yaml'
```

---

- **Ruby:** [committee](https://github.com/interagent/committee)
- **PHP:** [openapi-psr7-validator](https://github.com/lezhnev74/openapi-psr7-validator)
- **NodeJS:** [fastify](https://github.com/fastify/fastify/blob/master/docs/Validation-and-Serialization.md) or [express-ajv-swagger-validation](https://github.com/Zooz/express-ajv-swagger-validation)
- **Python:** [connexion](https://github.com/zalando/connexion)
- **Mojolicious:** [Mojolicious](https://metacpan.org/pod/Mojolicious::Plugin::OpenAPI)

---

```js
{
  "errors": [
    {
      "status": "422",
      "detail": "The property '#/widget/price' of type string 
did not match the following type: integer",
      "source": {
        "pointer": "#/widget/price"
      }
    }
  ]
}
```
---

<!-- .slide: data-background="img/docs-api-reuse.jpg" data-background-size="contain" data-background-color="#fff" -->

---

If you have validation code, you can delete it.

If this is a new application, you **don't need to write it**.

---

"Data-store Validations" like "is email unique" still need to happen 👍

---

Your test suite is proving the requests work properly

---

Your test suite can use the descriptions to prove the responses work properly

---

```rb
JsonMatchers.schema_root = "reference/example-api/models"

it 'should conform to user schema' do
  get "/users/#{subject.id}"
  expect(response).to match_json_schema('user')
end
```

<small>https://apisyouwonthate.com/blog/writing-documentation-via-contract-testing</small>

---

## Request Validation at Gateway

Can't find a middleware?

Middleware a bit slow in prod?

---

Gateways validate your payloads before your application server is called

---

<!-- .slide: data-background="img/gateway.png" data-background-size="contain" data-background-color="#fff" -->

Note: like cache servers

---

- AWS Gateway
- Azure Gateway
- [Express Gateway](https://www.express-gateway.io/docs/policies/customization/conditions/#json-schema)
- Tyk

---

Register a middleware in dev?

Register a gateway plugin in prod?

<small>Standards compliance means dev/prod parity.*</small>

---

_Another (third) source of truth for validation... the client!_

---

<!-- .slide: data-background="img/validation/client.jpg" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/validation/client-api-change.jpg" data-background-size="contain" data-background-color="#fff" -->

Note: Increased length is ok right?

---

<!-- .slide: data-background="img/validation/client-fire.jpg" data-background-size="contain" data-background-color="#fff" -->

---

JSON Schema at runtime

```text
Link: <http://example.com/schemas/user.json#>; rel="describedby"
```

---

```js
const ajv = new Ajv();
const userSchema = require('./cached-schema.json')

function validate(schema, data) {
  return ajv.validate(schema, data)
    ? true : ajv.errors;
}

const input = {
  name: "Lucrezia Nethersole",
  email: "l.nethersole@hotmail.com",
  age: 25
}

validate(userSchema, input); // true
```

---

```js
validate(userSchema, { ...input, email: 123 );

[
  {
    keyword: 'type',
    dataPath: '.email',
    schemaPath: '#/properties/email/type',
    params: { type: 'string' },
    message: 'should be string'
  }
]
 ```

---

```
[ 'Name is a required field' ]
[ 'Email should match format “email”' ]
[ 'Date Of Birth is in an invalid format, e.g: 1990–12–28' ]
[ 'Name should NOT be longer than 20 characters' ]
```

---

**How can we enforce style guides for docs?**

https://stoplight.io/spectral <!-- .element: class="fragment" -->

---

```yaml
rules:
  schema-names-pascal-case:
    description: Schema names MUST be written in PascalCase
    message: '{{property}} is not PascalCase: {{error}}'
    recommended: true
    type: style
    given: '$.components.schemas.*~'
    then:
      function: pattern
      functionOptions:
        match: '^[A-Z][a-zA-Z0-9]*$'
```

---

<!-- .slide: data-background="img/studio-spectral.png" data-background-size="contain" -->

---

**Reference Company-Wide Style Guides**

```yaml
extends:
  - "https://api.acme.com/style-guide.yml"
```

---

- Editor (Studio, VS Code coming...)
- CLI
- Git Hooks
- Continuous Integration

---

Consistent APIs = ⏰ 💰 🥳

---

<span style="font-size: 60pt">apisyouwonthate.com</span>

Join our [Slack](http://slack.apisyouwonthate.com/)

Subscribe to the [Podcast](https://apisyouwonthate.com/podcast)

Read the [Blog](https://apisyouwonthate.com/blog)
