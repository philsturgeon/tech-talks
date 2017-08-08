---
title: What Ruby Can Teach PHP About Building APIs
theme: night
---



# What <s>Rails</s> Ruby Can Teach PHP About Building APIs

### PHPNE 2017 / @philsturgeon
---
I built APIs with PHP 2009-2014
---
Switched to Rails for a job in 2014-present
---
First Half: Stuff I love about Ruby/Rails
Second Half: Stuff I hate about Ruby/Rails
---

- Amazing robust well supported gems

- Rack the defacto standard avoids need for PSR HTTP stuff

- Testing requests doesnt go over wire

- Awesome data factories

- describe-it spec-driven testing tools

- Automagically sniff/stub web connections from tests

- Simplistic state machines

- Serialization and Deserialization

- Inline REPL debugging

- Moneypatching... 🙈

---

## Packages in Ruby

- Gems released 2004

- People built gems for loads of stuff and worked together

---

## Packages in PHP

- PEAR released 1999

- CodeIgniter released 2006 to help people "avoid PEAR"

- ~1 million frameworks 2006-2012

---

# Packages in PHP

- Composer released 2009

- Ignoring Composer, frameworks build own package managers

  - CodeIgniter Sparks
  - Laravel Bundles
  - CakePHP Bakery
  - Fuel Cells
  - Zend Modules

---

## Packages in PHP

- Incompatible with each other

- Dev A builds for FW A, Dev B for FW B

- PSR-0 released 2010

---

## Ruby's Head Start

Ruby community has been building gems since 2004

Composer + PSR-0 packages didn't get popular until ~2012

---

## Ruby's Head Start

Ruby has spent 8 more years building packages than PHP

---

Ruby had far fewer web frameworks than PHP for this time:

- Sinatra
- Rails
- Merb (merged with Rails in 2008)
- others but not really

???
so focus was less split than PHP

---

PHP of course had:

- CakePHP
- CodeIgniter
- Fat-Free
- FuelPHP 😅
- Kohana
- Laravel
- Lithium
- Silex
- Symfony
- Yii
- Zend

---

Sinatra and Rails are both Rack-based, meaning many gems work with both

---

- Rack::Attack
- Rack::Cache
- Rack::Throttle
- Rack::Referrals
- Rack::Turnout
- Warden

---

No sinatra-oauth2-client

No rails-oauth2-client

Just oauth2-client

---

### No Ruby FIG Required

Rack means no need for PSR HTTP stuff

Defacto standards, and a willingness to work together early on, meant from the start efforts were joined.

This is the opposite of the FIG, which is trying to bridge the gap between very different projects, so their next versions they can converge a bit.

---

League was effort to do this

Make good stuff with enough weight that enough people will use

Get abandoned, crappy or gross alts to redirect to us

---

## Testing requests doesnt go over "wire"

- You don't want to start a dev server
- You'd need to spin it up and down hundreds/thousands of times
- Just unit testing controllers is not realistic
- Using enough Rack to similate real req/resp

---

## Testing requests doesnt go over "wire"

<dl>
  <dt>Ruby</dt>

  <dd>ActionDispatch (Rails)</dd>
  <dd>rack-test (Rack)</dd>
</dl>

---

- Awesome data factories
  - Factory Girl

---

- describe-it spec-driven testing tools
Ruby
  - RSpec

PHP
  Kahlan

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

Rails thinks PUT === PATCH

---

Rails defaults 401 messages to plain text:


---

Only way to deal is to override core methods:

```
def request_http_token_authentication(realm = "Application")
  self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
  render :json => {:error => "HTTP Token: Access denied."}, :status => :unauthorized
end
```
