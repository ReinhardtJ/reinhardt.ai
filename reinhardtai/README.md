# reinhardt.ai

test
Infrastructure for:
- [reinhardt.ai](https://reinhardt.ai) - Personal website with Obsidian content
- [timer.reinhardt.ai](https://timer.reinhardt.ai) - Simple interval timer application
- [khoj.reinhardt.ai](https://khoj.reinhardt.ai) - Self-hosted Khoj AI assistant

## Services

- **nginx-proxy**: Main reverse proxy for HTTP/HTTPS traffic
- **acme-companion**: SSL certificate renewal
- **obsidian-proxy**: Proxy for Obsidian content at reinhardt.ai
- **timer**: Interval timer app ([NoBullshitTimer](https://github.com/ReinhardtJ/NoBullshitTimer))
- **khoj-proxy**: Nginx proxy for Khoj with basic auth and 50MB upload limit
- **khoj-server**: AI service with database, search, and sandbox components

## Khoj Setup

The Khoj service is accessible through khoj-proxy with basic authentication. The proxy is configured to allow file uploads up to 50MB.

### Auth Setup

The configuration assumes a `.htpasswd` file exists in the repository folder. To create one:

```
htpasswd -c .htpasswd username
```

## NoBullshitTimer Setup

1. Clone this repository and [NoBullshitTimer](https://github.com/ReinhardtJ/NoBullshitTimer) in the same parent directory
2. Run `docker compose up -d`
