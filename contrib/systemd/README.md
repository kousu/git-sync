# systemd files

## Installation


```
make install-systemd
```

## Development

There isn't really a 'dev' environment for these,
especially because one of them needs to be built via template.
They get installed to `~/.local/share/systemd/user`. You can look at them in there. Remember you need to sometimes `systemd --user daemon-reload`.
