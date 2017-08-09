---
title: What Ruby Can Teach PHP About Building APIs
theme: league
revealOptions:
  transition: 'fade'
  slideNumber: true
---

# What <s>Rails</s> Ruby Can Teach PHP About Building APIs

### PHPNE 2017 / @philsturgeon

---

I built APIs with PHP 2009 - 2014

---

Switched to Rails for a job in 2014

---

<!-- .slide: data-background="img/intro-happy.jpg" -->

---

<!-- .slide: data-background="img/intro-sad.jpg" -->

---

<!-- .slide: data-background="img/intro-wtf.jpg" data-background-size="contain" -->

---

## Agenda

1. 📜

1. 😍

1. 😦

---

## 📜

---

## Gems released 2004

---

## PEAR released 1999

---

## ̴1 million frameworks 2005-2012

---

## Composer released 2009

---

## Framework Package Managers

- CodeIgniter Sparks

- Laravel Bundles

- CakePHP Bakery

- Fuel Cells

- Zend Modules

Note: Ignoring Composer, frameworks build own package managers

---

## PHP Had Frameworks FOR DAYS

CakePHP / CodeIgniter / Fat-Free / FuelPHP (😅)
Kohana / Laravel / Lithium / Silex / Symfony / Yii / Zend

Note: No similarities between frameworks, nothing worked in more than one

fuel-oauth2-client, codeigniter-oauth2-client, laravel-oauth2-client, etc

---

## Ruby had a few frameworks

Sinatra / Rails / Merb*

Note: merb merged in 2008

focus was less split than PHP

---

## Ruby gems are mostly agnostic

No sinatra-oauth2-client

No rails-oauth2-client

Just oauth2-client

---

# PSR-0 released 2010

Note: Generally ignored by most, me too

---

## PHP-FIG made agnostic composer packages viable ̴2012

---

### Ruby has spent 8 more years building packages

2004 vs 2012

---

## Ruby didn't need a Ruby-FIG

### Willingness and ability to cooperate

Note: Fewer silos to split work

Defacto standards + willingness to work together early on

Opposite of the FIG, bridge gap very different projects to converge

---

### Gems can change ownership easily

gem "oauth2-client"

Note: Creator isn't important, authors arent held hostage

---

### Composer vendor create "brand oppertunity"

## Many devs want vendorname/fame

Note: That can be seen League reaction

Other ways to do it
help people / prs / issues
blog

---

### The PHP League learned a lot from Ruby

A critical mass of users creates a defacto standard

Note: Abandoned alts redirected to us

---

### The PHP League learned a lot from Ruby

The (current) author is not as important as the package

---

### The PHP League learned a lot from Ruby

Tying code to a framework is a waste of everyones time

---

### The PHP League literally ported code from Ruby

🤷‍♂️

---

## Ruby community created Rack

### Rack = PSR-7 + PSR-15 (Draft)

Note: Sinatra and Rails are both Rack-based, meaning many gems work with both

---

### Rack HTTP middlewares helps building APIs

Rack::Attack / Rack::ConditionalGet / Rack::ETag / Rack::Cache / Rack::Proxy / Rack::Referrals / Rack::Throttle / Rack::Turnout


Note: Many middlewares really help building APIs

---

## No need for Framework-specific API packages

### e.g: Dingo

---

## What about these amazing API, HTTP & Testing tools?!

---

## 😍

---

Rails has --api mode

Strips out cookies, sessions, views, etc.

---

Rails handles conditional GET (ETag and Last-Modified)

stale?

---

HEAD requests: Rails will transparently convert HEAD requests into GET ones, and return just the headers on the way out. This makes HEAD work reliably in all Rails APIs.

---

Rails implements a lot of functionality as Rack Middleware

(PHP frameworks should do this)

---

## describe-it testing

TODO Show it off

---

## describe-it testing

<dl>
<dt>Ruby</dt>
<dd>RSpec</dd>
</dl>

<dl>
<dt>PHP</dt>
<dd>Kahlan</dd>
</dl>

---

## Testing requests doesnt go over "wire"

- You don't want to start a dev server
- You'd need to spin it up and down hundreds/thousands of times
- Just unit testing controllers is not realistic
- Using enough Rack to similate real req/resp

---

## Testing requests doesn't go over "wire"

<dl>
  <dt>Ruby</dt>

  <dd>ActionDispatch (Rails)</dd>
  <dd>rack-test (Rack)</dd>
</dl>

---

- Awesome data factories
  - Factory Girl

---

Automagically sniff/stub web connections from tests

Ruby
  - VCR

PHP
  - PHP-VCR

---

- Simplistic state machines

Ruby
  - Statesman
  - AASM

PHP
  - TODO

---

- Serialization and Deserialization

Ruby
  - ActiveModel Serializers
  - OAT
  - ROAR

PHP

---

- Inline REPL debugging

TODO INSERT VIDEO OF DOPE SO EASY

---

- Moneypatching... 🙈

- Good for testing, bad for anything else

- Kahlan has monkey patching for testing!

---

## 😦

---

## Rails has no respect

```
{
  "action" : "foo"
}
```

```
def create
  params[:action] # create 😭
end
```

Form data, JSON param, query string...

Rails kills it all.

---

## Rails thinks PUT === PATCH

[_They are very different_](https://philsturgeon.uk/api/2016/05/03/put-vs-patch-vs-json-patch/)

---

## Rails has some weird defaults

![Why the hell is this plain text](img/http-access-denied-text.png)

---

Sometimes you gotta override core methods

```

def request_http_token_authentication(realm = "Application")

  authenticate = %(Token realm="#{realm.gsub(/"/, "")}")

  self.headers["WWW-Authenticate"] = authenticate

  render json: { error: "HTTP Token: Access denied." },
    status: :unauthorized

end

```

---

And Other Minor Gripes

![Grumble grumble](img/grumpy.jpg)

---

### Rails is ok

## Ruby is great

---

Play with some gems when you get home

---

Play with _other_ languages when you get home

---

### Take inspiration from these experiences
## Better the PHP ecosystem
