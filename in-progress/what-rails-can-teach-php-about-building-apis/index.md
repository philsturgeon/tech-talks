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

`gem "oauth2-client"`

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

## What about these amazing API, HTTP & Testing tools?!

---

## 😍

---

`rails new --api your-project`

### No cookies / sessions / browser stuff

---

### Rack HTTP middleware helps building APIs

Rack::Attack / Rack::ConditionalGet / Rack::ETag / Rack::Cache / Rack::Proxy / Rack::Referrals / Rack::Throttle / Rack::Turnout

Note: Many middlewares really help building APIs

---

## HTTP Client Middleware

Request: auth, refresh tokens, format body, error if missing user agent

---

## HTTP Client Middleware

Response: autoconvert JSON/XML, turn status codes into exceptions, etc

---

### Combining Client + Server Middleware

```
+Deprecate.new(date: '2017-07-13 15:42:12 GMT')
def create
  # ...
end
```

---

### Combining Client + Server Middleware

Server Middleware injects HTTP Header

`Sunset: Thu, 13 Jul 2017 15:42:12 GMT`

---

### Combining Client + Server Middleware

HTTP Client Middleware freaks out on the CLI!

`Endpoint Deprecated: Will cease to function in 26 days!`

---

Rails implements a lot of functionality as Rack Middleware

---

### Rails handles conditional GET

## ETag and Last-Modified

---

```
def show
  @article = Article.find(params[:id])

  if stale?(etag: @article, last_modified: @article.updated_at)
    @statistics = @article.really_expensive_call
    respond_to do |format|
      # all the supported formats
    end
  end
end
```

---

### Without E-Tag

```text
Completed 200 OK in 35ms (Views: 33.4ms | ActiveRecord: 0.3ms)
```

---

### With E-Tag

```text
Completed 304 Not Modified in 2ms (ActiveRecord: 0.3ms)
```

---

`35ms vs 2ms = 94% improvement!`

---

_[Read more on ETags](https://robots.thoughtbot.com/introduction-to-conditional-http-caching-with-rails)_

---

Rails: HEAD Requests

Note: Rails will transparently convert HEAD requests into GET ones, and return just the headers on the way out

---

### Rack = PSR-7 + PSR-15 (Draft)

PSR-7 is just the message

(RelayPHP / EquipPHP / etc.)

---

### Rack = PSR-7 + PSR-15 (Draft)

PSR-15 standardises passing middlewares around

---

[Read more on HTTP middleware in PHP](https://philsturgeon.uk/php/2016/05/31/why-care-about-php-middleware/)

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

### Awesome data factories

## Factory Girl

---

``` ruby
FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    admin false
  end

  factory :admin, class: User do
    first_name "Admin"
    last_name  "User"
    admin      true
  end
end
```

---

``` ruby
# Returns a User instance that's not saved
user = build(:user)

# Returns a saved User instance
user = create(:user)
```

---

### Intercept/block web connections for tests

Allow exceptions IF YOU MUST

---

### Intercept/block web connections for tests

Otherwise... record and replay

---

<!-- .slide: data-background="https://php-vcr.github.io/img/phpvcr-overview.png" data-background-size="contain" -->

---

## Simple State machines

<dl>
<dt><strong>Ruby</strong></dt>
<dd>Statesman</dd>
<dd>AASM</dd>
</dl>

<dl>
<dt><strong>PHP</strong></dt>
<dd>TODO</dd>
<dd>&nbsp;</dd>
</dl>

---

- Serialization and Deserialization

Ruby
  - ActiveModel Serializers
  - OAT
  - ROAR

PHP
  - [Hyperspan](https://github.com/vlucas/hyperspan)

---

- Inline REPL debugging

TODO INSERT VIDEO OF DOPE SO EASY

---

## Moneypatching 🙈

---

### Moneypatching 🙈

### Good for testing, bad for everything else

---

### Kahlan has monkey patching for testing!

---

```php
it("shows some examples of function stubbing", function() {

  allow('RabbitMQ')->toReceive('publish')
    ->with('a very important message')
    ->andReturn(true);

  $subject->doImportantThing();
}
```

---

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">PHP Developers. What is your opinion on Kahlan?</p>&mdash; Scarbutt O&#39;Doul (@philsturgeon) <a href="https://twitter.com/philsturgeon/status/895418592916684800">August 9, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

---

Use [Kahlan](https://kahlan.github.io/docs/) more!!

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

---

## Better the PHP ecosystem
