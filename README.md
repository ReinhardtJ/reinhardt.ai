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

**khoj-server**
The Khoj AI service that is directly accessible via the nginx reverse proxy with basic authentication.

## Khoj Server Configuration

This repository contains a configuration for the Khoj service. The service is directly accessible through the main nginx reverse proxy with basic authentication.

### Architecture

The system uses a simple, direct approach:

1. **Main Nginx Proxy**:
   - Handles incoming requests
   - Enforces basic authentication
   - Directly forwards authenticated requests to the Khoj server
   - Manages SSL certificates via acme-companion

This simplified architecture removes the previous two-proxy approach and username:password@domain authentication, making the service more straightforward to access and maintain.

### How It Works

The access flow works as follows:

1. When a request comes in to khoj.reinhardt.ai:
   - The nginx proxy requires basic authentication
   - If authentication is successful, the request is forwarded directly to the Khoj server
   - If authentication fails, a 401 Unauthorized response is returned

### Setup

1. Create an .htpasswd file with your desired credentials:
   ```
   htpasswd -c .htpasswd username
   ```

2. Start the services using Docker Compose:
   ```
   docker-compose up -d
   ```

3. Access the Khoj service at:
   - `https://khoj.reinhardt.ai` (will prompt for credentials)

### Security Considerations

The setup uses standard basic authentication at the proxy level. While basic authentication provides a simple security layer, it's important to note:

1. Credentials are transmitted with each request (though encrypted over HTTPS)
2. For higher security applications, consider implementing additional security measures

**khoj-server and related services**
the Khoj AI service and its dependencies (database, search, sandbox).

# Run
Make sure docker is installed.

To run reinhardt.ai and timer.reinhardt.ai, clone this repository and
https://github.com/ReinhardtJ/NoBullshitTimer so that both repositories
are located next to each other in the same folder.

Then, run `docker compose up`. This starts the entire infrastructure with 
docker.
