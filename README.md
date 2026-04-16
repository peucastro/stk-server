# SuperTuxKart Server Docker Image

A Docker image for running a SuperTuxKart server.

## Quick Start (Docker)

```bash
# Build the image
docker build -t stk-server .

# Run with default settings
docker run -d -p 2757:2757/udp -p 2759:2759/udp --name stk-server stk-server

# Or use docker-compose
docker compose up -d
```

## Configuration

### Via Environment Variables

```bash
docker run -d \
  -p 2757:2757/udp \
  -p 2759:2759/udp \
  -e SERVER_NAME="My STK Server" \
  -e MAX_PLAYERS=8 \
  -e SERVER_MODE=3 \
  stk-server
```

### Via Config File

Mount a config file at `/app/config.xml`:

```bash
docker run -d \
  -p 2757:2757/udp \
  -p 2759:2759/udp \
  -v ./config.xml:/app/config.xml \
  stk-server
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SERVER_NAME` | STK Server | Server name |
| `SERVER_PORT` | 2759 | Server port |
| `SERVER_MODE` | 3 | Game mode (0=GP, 1=Time Trial, 3=Race, 6=Soccer, 7=FFA, 8=CTF) |
| `SERVER_DIFFICULTY` | 0 | Difficulty (0=Beginner, 1=Intermediate, 2=Expert, 3=SuperTux) |
| `MAX_PLAYERS` | 8 | Maximum players |
| `WAN_SERVER` | false | Enable public internet server |
| `MOTD` | | Message of the day |
| `SERVER_PASSWORD` | | Private server password |

For WAN server, also set:

- `USERNAME` - STK account username
- `PASSWORD` - STK account password
