# reinhardt.ai

This repository maintains the infrastructure running under [reinhardt.ai](https://reinhardt.ai) and [timer.reinhardt.ai](https://timer.reinhardt.ai).

# Setup
The setup uses docker with a docker-compose yaml file to define and run the 
services. Currently, the setup consists of the following services:

**nginx-proxy**

a nginx reverse proxy exposing the server and taking care of http/https traffic

**acme-companion** 

a service which automatically renews the SSL certificates

**obsidian-proxy** 

the obsidian proxy which replaces the publish.obsidian.me url for reinhardt.ai 

**timer**
a simple interval timer app hosted as a blazor web application. See
https://github.com/ReinhardtJ/NoBullshitTimer

**khoj-proxy**
a Nginx proxy for the Khoj service with basic authentication support. It allows accessing the Khoj service with basic auth credentials.

## Khoj Nginx Proxy with Basic Authentication

This repository contains a custom Nginx proxy configuration for the Khoj service with basic authentication support. The proxy allows for two methods of authentication:

1. Standard basic authentication using the Authorization header
2. Embedding credentials directly in the URL using the format: `https://username:password@domain`

### Architecture

The system uses a two-proxy approach:

1. **Outer Proxy (nginx-outer)**:
   - Handles incoming requests
   - Extracts credentials from URLs when present
   - Creates proper Authorization headers
   - Forwards requests to the inner proxy

2. **Inner Proxy (nginx-inner)**:
   - Enforces basic authentication using .htpasswd
   - Proxies authenticated requests to the Khoj server

This separation ensures that URL credentials are properly validated against the .htpasswd file.

### How It Works

The authentication flow works as follows:

1. When a request comes in with credentials in the URL (e.g., `/https://username:password@example.com`):
   - The outer proxy extracts the credentials
   - It creates a proper Authorization header
   - It forwards the request to the inner proxy with this header

2. The inner proxy:
   - Validates the Authorization header against the .htpasswd file
   - If valid, forwards the request to the Khoj server
   - If invalid, returns a 401 Unauthorized response

For standard requests without URL credentials, the inner proxy handles basic authentication directly.

### Setup

1. Create an .htpasswd file with your desired credentials:
   ```
   htpasswd -c .htpasswd username
   ```

2. Start the services using Docker Compose:
   ```
   docker-compose up -d
   ```

3. Access the Khoj service using either:
   - Standard basic auth: `https://khoj.reinhardt.ai` (will prompt for credentials)
   - URL credentials: `https://khoj.reinhardt.ai/https://username:password@example.com`

### Security Considerations

While embedding credentials in URLs is convenient for API access, it's generally not recommended for sensitive applications as:

1. Credentials may be logged in server logs
2. Credentials may be visible in browser history
3. Credentials may be transmitted in Referer headers

Use this feature only in trusted environments or for non-sensitive applications.

**khoj-server and related services**
the Khoj AI service and its dependencies (database, search, sandbox).

# Run
Make sure docker is installed.

To run reinhardt.ai and timer.reinhardt.ai, clone this repository and
https://github.com/ReinhardtJ/NoBullshitTimer so that both repositories
are located next to each other in the same folder.

Then, run `docker compose up`. This starts the entire infrastructure with 
docker.
