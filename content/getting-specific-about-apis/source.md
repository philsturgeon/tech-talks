---
title: "Getting Specific About APIs"
theme: league
revealOptions:
  transition: 'fade'
  slideNumber: true
  autoPlayMedia: true
---

## Getting Specific About APIs

### Label your hecking units

NYPHP

<small>@philsturgeon</small>

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

---

<!-- .slide: data-background="img/mars-1.jpg" -->

---

<!-- .slide: data-background="img/lol.jpg" data-background-size="contain" data-background-color="#000" -->

---

<!-- .slide: data-background="img/mars-article.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/mars_climate_orbiter.png" data-background-size="contain" data-background-color="#000" -->

---

> "That is so dumb," said John Logsdon, director of George Washington University's space policy institute.

---

<!-- .slide: data-background="img/pokeapi.png" data-background-size="contain" data-background-color="#fff" -->

---

Crap Documentation is written in...

- Markdown Tables 🤔
- HTML 😴
- Word Documents 😖
- Excel Spreadsheets 🤣
- Wikis 😩

---

[json-schema.org/specification.html](http://json-schema.org/specification.html)

draft 07 right meow

---

## JSON Schema

```
{
    "type": "object",
    "properties": {
        "id": {
            "type": "number"
        },
        "name": {
            "type": "string"
        },
        "price": {
          "type": "number",
          "exclusiveMinimum": 0
        }
    },
    "required": ["id", "name", "price"]
}
```

---

``` json
"title": "Some Field",
"description": "Explain the thing in longer form.",
"default": "Default value",
"readOnly": true,
"maximum": 10,
"examples": ["foo", "bar"]
```

---

This can be used to generate API Reference docs

---

BUT MORE IMPORTANTLY

---

- Client-side payload validation
- Server-side payload validation
- Contract testing
- Form Generation
- Code Generation
- SDKs
- Mock Servers

---

JSON Schema had two vocabularies:

- Core
- Validation

---

## Client-side Payload Validation

Clients need to validate requests before form submission

Heck no am I waiting for the server to respond for per-field as-you-type validation)

---

Duplicating validation logic on server and various clients is dangerous and **boring**

---

## Validation Hell

E.g: A "name" string changes max length from 20 to 40

Note: The API devs decide making validation rules lenient != breaking. they deploy the change with a max length of 40 characters, and one client-app deploys an update to match, increasing the validation to 40. Despite various client applications still having the hardcoded max length at 20 characters, everyone feels pretty happy about this.

---

Expose the JSON Schema's in the `Link` header

```
GET /hats
```

```
Link: <http://example.com/schemas/hats.json#>; rel=”describedby”
```

Now you know what a collection of hats look like...

---

```
{
  ... snip ...
  "items": {
    "$ref": "http://example.com/schemas/hat.json"
  }
}
```

And you know what a hat looks like...

---

``` js
const Ajv = require('ajv');
const ajv = new Ajv();

// Fetch the JSON content that was downloaded from URL
const hatSchema = require('./cached-hat.json')

// Make a little helper for validating
function validate(schema, data) {
  return ajv.validate(schema, data)
    ? true : ajv.errors;
}

// ... continued
```

---

``` js
// Pretend we've submitted a form
const input = {
 id: "ABC-123",
 name: "Fluffy",
 price: 10
};

// Is the whole input valid?
validate(hatSchema, input); // true

// Ok screw up validation...
input['price'] = -1;
validate(hatSchema, input); // [ { keyword: 'exclusiveMinimum', dataPath: '.price', ...
```

---

We got either a true or an array of errors, which is pretty handy

---

JSON Schema validators are currently pretty bad at generating human errors

---

Lets look at a more advanced example.

---

```
{
  "$id": "http://example.com/schemas/user.json",
  "type": "object",
  "definitions": {},
  "$schema": "http://json-schema.org/draft-07/schema#",
  "properties": {
    "name": {
      "title": "Name",
      "type": "string",
      "description": "Users full name supporting unicode but no emojis.",
      "maxLength": 20
    },
    "email": {
      "title": "Email",
      "description": "Like a postal address but for computers.",
      "type": "string",
      "format": "email"
    },
    "date_of_birth": {
      "title": "Date Of Birth",
      "type": "string",
      "description": "Date of uses birth in the one and only date standard: ISO 8601.",
      "format": "date",
      "example": "1990–12–28"
    }
  },
  "required": [
    "name"
  ]
}
```

---

And let's write some over the top code to make human errors

---

```
function buildHumanErrors(errors) {
  return errors.map(function(error) {
    if (error.params.missingProperty) {
      const property = pointer.get(userSchema, '/properties/' + error.params.missingProperty);
      return property.title + ' is a required field';
    }
    const property = pointer.get(userSchema, '/properties' + error.dataPath);
    if (error.keyword == 'format' && property.example) {
      return property.title + ' is in an invalid format, e.g: ' + property.example;
    }
    return property.title + ' ' + error.message;
  });
}
```

---

```
[
  { },
  { name: "Lucrezia Nethersole", email: "not-an-email" },
  { name: "Lucrezia Nethersole", date_of_birth: 'n/a' },
  { name: "Lucrezia Nethersole Has Many Many Names" }
].forEach(function(input) {
  console.log(
    buildHumanErrors(validate(userSchema, input))
  );
});
```

---

```
[ 'Name is a required field' ]
[ 'Email should match format "email"' ]
[ 'Date Of Birth is in an invalid format, e.g: 1990–12–28' ]
[ 'Name should NOT be longer than 20 characters' ]
```

---

Don't stop at string errors. Update the UI.

![](img/red-boxes.png)

---

![](img/tooltips.png)

Can even add tooltips based on format/example values

---

Use i18n to give errors in multiple languages

---

JSON Schema enabled evolution without the **Validation Hell**

---

## Form Generation

- [mozilla-services/react-jsonschema-form](https://github.com/mozilla-services/react-jsonschema-form)
- [json-schema-form/json-schema-form-core](https://github.com/json-schema-form/json-schema-form-core)
- soon... official JSON Schema UI vocabulary

---

```
{
  "boolean": {
    "radio": {
      "ui:widget": "radio"
    },
    "select": {
      "ui:widget": "select"
    }
  },
  "string": {
    "textarea":  {
      "ui:widget": "textarea",
      "ui:options": {
        "rows": 5
      }
    },
    "color": {
      "ui:widget": "color"
    }
  },
  "secret": {
    "ui:widget": "hidden"
  },
  "disabled": {
    "ui:disabled": true
  },
  "readonly": {
    "ui:readonly": true
  },
  "widgetOptions": {
    "ui:options": {
      "backgroundColor": "yellow"
    }
  },
  "selectWidgetOptions": {
    "ui:options": {
      "backgroundColor": "pink"
    }
  }
}
```

---

<!-- .slide: data-background="img/json-schema-form-1.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/json-schema-form-2.png" data-background-size="contain" data-background-color="#fff" -->

---

## Server-side Validation

Exactly the same JSON Schema validation can be used in app

---

## Server-side Validation

Delete 345974989 lines of controller/model validations

---

## Server Implementations

- [apioo/fusio](https://github.com/apioo/fusio)
- [hskrasek/laravel-jsonschema-validation-example](https://github.com/hskrasek/laravel-jsonschema-validation-example)

---

<!-- .slide: data-background="img/server-validation.gif" data-background-size="contain" data-background-color="#000" -->

---

## API Gateway Validation

Don't even bother the application server unless the payload is valid.

---

<!-- .slide: data-background="img/api-gateway-json-schema.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/tyk.png" -->

---

JSON Schema is for more than HTTP APIs

Describe JSON anywhere, e.g: AMQP messages

---

<!-- .slide: data-background="img/data-model-service-model.png" data-background-size="contain" -->

---

JSON Schema is similar (but not the same as) XML Schema

Both only document data model

---

<!-- .slide: data-background="img/data-model-service-model-wsdl.png" data-background-size="contain" -->

---

"REST is the new SOAP"

Hahahaha no but data / service modeling has made a comeback

---

<!-- .slide: data-background="img/data-model-service-model-openapi.png" data-background-size="contain" -->

---

OpenAPI can handle the service + data

---

## Basic OpenAPI

```
openapi: 3.0.0
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

```
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
                type: array
                items:
                  $ref: '#/components/schemas/hat'
```

---

```
components:
  schemas:
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

Notice that structure? It's basically JSON Schema in YAML...

---

You can actually write JSON Schema data models and `$ref` them from the OpenAPI service model

---

These schemas can be JSON Schema (draft v4) files, with caveats...

---

<!-- .slide: data-background="img/json-schema-oai-differences.png" data-background-size="contain" -->

---

<!-- .slide: data-background="img/osa-json-demo.gif" data-background-size="contain" -->

---

[hskrasek/jsonschema-input-validator](https://github.com/hskrasek/jsonschema-input-validator)

---

OpenAPI has the best API Reference tools currently

---

<!-- .slide: data-background="img/human-gross.png" data-background-size="contain" data-background-color="#fff" -->

---

<!-- .slide: data-background="img/human-nice.png" data-background-size="contain" -->

---

## SDK Generation

- apimatic.io
- stoplight.io

---

## Mirror to Postman

1. apimatic.io/transformer
1. Postman Pro API

---

## Mock API servers

- [prism](http://stoplight.io/platform/prism/)
- stoplight.io
- Postman Mock Server

---

## JSON Schema gets a Service Model

The 3rd (newest) JSON Schema vocabulary is HyperSchema

---

<!-- .slide: data-background="img/data-model-service-model-json-hyper.png" data-background-size="contain" -->

---

Instead of focusing on "paths", HyperSchema links from one thing to another

---

Links send a user agent from `/` to `/hats` or `/cats`

---

When landing on `GET /hats/123` it offers a `purchase` link
... so long as `in_stock: true`

---

``` json
{
  "$id": "hat",
  "if": {
    "required": ["in_stock"],
    "properties": {
      "in_stock": {"const": true}
    }
  },
  "then": {
    "links": [{
      "rel": "buy",
      "href": "cart",
      "submissionSchema": {
        "$ref": "./cart.json#/add"
      }
    }]
  }
}
```

---

I'm talking about *hypermedia* folks!

---

Unlike Siren/HAL/JSON-API, etc., the links and the metadata are not in the payload

---

Optional hypermedia controls are great. Clients can use em if they want, skip em if they don't.

---

## JSON HyperSchema API Reference

[Doca](https://github.com/cloudflare/doca) can generate docs from HyperSchema

---

RPC? OpenAPI

---

REST? OpenAPI

or JSON Schema + JSON HyperSchema

or Both!

---

OpenAPI v3.1 might support JSON Schema *proper* as an "Alternative Syntax"

(Remove the need for conversion and discrepancies)

---

Get started with either of them. There are so many amazing benefits.

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
