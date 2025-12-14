# reinhardt.ai

Infrastructure for [reinhardt.ai](https://reinhardt.ai) and self-hosted services.

## Services

### VPS (OVH)
- **obsidian-proxy** - Personal website with Obsidian content
- **no-bullshit-timer** - Simple interval timer ([NoBullshitTimer](https://github.com/ReinhardtJ/NoBullshitTimer))
- **agent-zero-server** - General Purpose AI agent (deprecated)
- **nginx-proxy** + **acme-companion** - Reverse proxy with automatic SSL

### Selfhost (Netcup)
- **immich** - Photo management and backup
- **affine** - Knowledge base and collaborative notes
- **stirlingpdf** - PDF manipulation tools
- **khoj** - AI assistant (multiple instances for different use cases)
- **portainer** - Docker container management UI
- **agent-zero-rr** - General Purpose AI agent (updated instance)
- **reverse-proxy** - Nginx reverse proxy with automatic SSL

## Structure

- `vps/` - Services hosted on OVH
- `selfhost/` - Services hosted on Netcup

**Note:** The split between VPS and selfhost reflects an ongoing migration from OVH to Netcup.
