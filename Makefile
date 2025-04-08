.PHONY: all clean certs check-mkcert create-cert-dir start stop rm logs restart update status watchtower ensure-env

# Default target shows usage
all:
	@echo "Usage:"
	@echo "  make certs     - Generate certificates"
	@echo "  make clean     - Remove certificates"
	@echo "  make start     - Start services"
	@echo "  make stop      - Stop services"
	@echo "  make rm        - Remove services and volumes"
	@echo "  make logs      - Show logs"
	@echo "  make restart   - Restart services"
	@echo "  make update    - Update and restart services"
	@echo "  make status    - Show service status"
	@echo "  make watchtower- Update containers using watchtower"

# Certificate management commands
check-mkcert:
	@which mkcert > /dev/null || (echo "mkcert is not installed. Please install it first." && exit 1)

create-cert-dir:
	@mkdir -p ./certs

# Generate certificates using mkcert
certs: check-mkcert create-cert-dir
	mkcert -install \
		-cert-file ./certs/cert.pem \
		-key-file ./certs/key.pem \
		"ai.test" \
		"localhost" \
		"127.0.0.1" \
		"::1"

clean:
	rm -rf ./certs

# Ensure .env file exists
ensure-env:
	@if [ ! -f .env ]; then \
		echo "Creating .env file..."; \
		touch .env; \
	fi

# Docker service management commands
start: ensure-env
	@if docker-compose ps | grep open-webui | grep -q "Up"; then \
		echo "Open WebUI is already running."; \
	else \
		docker-compose up -d --wait --remove-orphans; \
		echo "Open WebUI and Caddy are now running."; \
		which open > /dev/null && open https://${WEBUI_URL:?} || echo "Services started at https://${WEBUI_URL}"; \
	fi

up: start logs

stop:
	docker-compose down
	@echo "Open WebUI and Caddy have been stopped."

down: stop

rm:
	docker-compose down --volumes --remove-orphans
	@echo "Open WebUI and Caddy have been removed."

logs:
	docker-compose logs -f

restart:
	docker-compose restart
	@echo "Open WebUI and Caddy have been restarted."

pull:
	docker-compose pull

update: down pull start

status:
	docker-compose ps

watchtower:
	docker run \
		--rm \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		containrrr/watchtower \
		--run-once open-webui caddy-proxy
