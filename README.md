# Local AI with Open WebUI and Caddy

This project provides a streamlined local development environment using Docker Compose with automatic SSL certificate management. It sets up a secure local environment with Open WebUI and Caddy as a reverse proxy.

## Prerequisites

- Docker and Docker Compose
- mkcert (for SSL certificate generation)
- make (usually pre-installed on Unix-based systems)

### Installing mkcert

mkcert is required for generating trusted SSL certificates for local development.

**macOS:**
```bash
brew install mkcert
```

**Linux:**
```bash
sudo apt install mkcert    # Ubuntu/Debian
sudo dnf install mkcert    # Fedora
```

**Windows:**
```bash
choco install mkcert
```

## Getting Started

1. Clone this repository
2. Generate SSL certificates:
   ```bash
   make certs
   ```
3. Start the services:
   ```bash
   make start
   ```

The environment will be available at https://localhost or https://ai.test (if configured in your hosts file).

## Available Commands

### Certificate Management
- `make certs` - Generate SSL certificates for local development
- `make clean` - Remove generated certificates

### Service Management
- `make start` - Start all services (alias: `make up`)
- `make stop` - Stop all services (alias: `make down`)
- `make rm` - Remove services and volumes
- `make logs` - View service logs in follow mode
- `make restart` - Restart all services
- `make update` - Pull latest images and restart services
- `make status` - Show current service status

### Container Updates
- `make watchtower` - Update containers using Watchtower (one-time check)

## Configuration

The project uses a `.env` file for configuration. If it doesn't exist, it will be automatically created when running `make start`.

### Default Domains

The SSL certificates are configured for:
- localhost
- ai.test
- 127.0.0.1
- ::1 (IPv6 localhost)

## Architecture

The environment consists of two main services:
1. **Open WebUI** - Main application interface
2. **Caddy** - Reverse proxy handling SSL termination

## Troubleshooting

1. **Certificate Issues**
   - Run `make clean` followed by `make certs` to regenerate certificates
   - Ensure mkcert is properly installed

2. **Service Won't Start**
   - Check if ports are available using `make status`
   - Review logs with `make logs`

3. **Container Updates**
   - Use `make update` to pull latest images
   - For automatic updates, consider running Watchtower as a service

## Development Workflow

1. Start the services:
   ```bash
   make start
   ```

2. View logs while services are running:
   ```bash
   make logs
   ```

3. When finished, stop the environment:
   ```bash
   make stop
   ```

## Contributing

1. Ensure you have the latest certificates and images:
   ```bash
   make clean certs
   make update
   ```

2. Test your changes thoroughly
3. Submit a pull request with a clear description of your changes

## License

See [LICENSE](./LICENSE) for details.
