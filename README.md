# Katter

Implementation of twitter clone in elixir using in memory stores to index
messages by mention and username, exposed via a simple Plug based HTTP Endpoint.

Kata Source: https://github.com/cork-functional-programmers/katter/

## Run

```
iex -S mix
```

## Usage

`GET /katter/messages?username=$username`

Get Messages from a given user

```
$ curl http://localhost:1337/katter/messages?username=holsee
```

`GET /katter/messages?mention?$username`

Get Messages where a given user was mentioned


```
$ curl http://localhost:1337/katter/messages?mention=russel
```

`POST /katter/messages`

Message Format:
``` json
{
 "username" : $username,
 "messages" : $message,
 "mentions" " [$username]
}
```

Helper script to post message:

`./scripts/submit.sh holsee "Hello World!" '["russel", "priort"]'


