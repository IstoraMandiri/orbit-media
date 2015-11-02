# orbit:media

### (Alpha) A tiny generic media upload form for Orbit

![Orbit Media Screenshot](http://i.imgur.com/Br1QlSs.jpg)

## Usage

Use `{{> OrbitMedia}}` in your admin UI to add the upload template.

For permissions, just enable them like a typical CFS collection:

```
Orbit.Media.allow
  'remove': (userId, file) -> true
  'insert': (userId, file) -> true
  'update': (userId, file) -> true
  'download' : -> true
```

## TODO

```
- Better docs
- Tests
```

## License

MIT 2015, TAPevents