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

Mount a config file at `/app/config.xml` (or `/app/config/server-config.xml`):

```bash
docker run -d \
  -p 2757:2757/udp \
  -p 2759:2759/udp \
  -v ./config.xml:/app/config.xml \
  stk-server
```

## Network Ports

STK server needs two UDP ports exposed:

- **2757**: Server discovery port (clients use this to find your server)
- **2759**: Server port (main server communication)

## Environment Variables

The defaults in the tables below are the image runtime defaults from `entrypoint.sh`.
The `.env.example` file is only a sample profile you can customize.

### Basic Server Settings

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `SERVER_NAME` | STK Server | Server name displayed to players |
| `LAN_SERVER_NAME` | (uses SERVER_NAME) | Server name for LAN discovery |
| `SERVER_PORT` | 2759 | Server port |
| `SERVER_MODE` | 3 | Game mode (0=Normal GP, 1=Time Trial GP, 3=Normal Race, 4=Time Trial, 6=Soccer, 7=FFA, 8=CTF) |
| `SERVER_DIFFICULTY` | 0 | Difficulty (0=Beginner, 1=Intermediate, 2=Expert, 3=SuperTux) |
| `MAX_PLAYERS` | 8 | Maximum concurrent players |
| `MAX_PLAYERS_IN_GAME` | 0 | Max players actively in race (0 = all players can play) |

### Game Settings

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `MOTD` | (empty) | Message of the day |
| `SERVER_PASSWORD` | (empty) | Private server password (empty = public) |
| `CHAT` | true | Enable chat |
| `CHAT_CONSECUTIVE_INTERVAL` | 8 | Minimum seconds between user messages |
| `TRACK_VOTING` | true | Allow players to vote for tracks |
| `VOTING_TIMEOUT` | 30 | Track voting timeout (seconds) |
| `TEAM_CHOOSING` | true | Allow team selection in team modes |
| `AUTO_END` | false | Automatically end race when first kart finishes |
| `MIN_START_PLAYERS` | 2 | Minimum players to start race |
| `START_GAME_COUNTER` | 60 | Countdown before race starts (seconds) |
| `ENABLE_CONSOLE` | false | Enable in-game console |
| `SERVER_CONFIGURABLE` | false | Allow server owner to change difficulty/mode in lobby |

### Game Mode Specific

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `GP_TRACK_COUNT` | 3 | Number of tracks in Grand Prix |
| `SOCCER_GOAL_TARGET` | false | Soccer goals mode (`true`) or timed mode (`false`) |
| `STRICT_PLAYERS` | false | Strict player validation |
| `RANKED` | false | Enable ranked matches |
| `LIVE_SPECTATE` | true | Allow live join/spectate for in-progress games |
| `LIVE_PLAYERS` | true | Backward-compatible alias for `LIVE_SPECTATE` |
| `REAL_ADDON_KARTS` | true | Send real addon kart physics to clients |

### Physics & Gameplay

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `MAX_PING` | 300 | Maximum ping in milliseconds |
| `JITTER_TOLERANCE` | 100 | Jitter tolerance (milliseconds) |
| `KICK_HIGH_PING` | false | Kick players with high ping |
| `HIGH_PING_WORKAROUND` | true | Apply high ping workaround |
| `KICK_IDLE_SECONDS` | 60 | Kick idle players after N seconds |
| `STATE_FREQUENCY` | 10 | Server state update frequency (Hz) |
| `VALIDATION_TIMEOUT` | 20 | Kart validation timeout (seconds) |
| `VALIDATING_PLAYER` | true | Validate player karts |

### CTF & FFA Modes

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `CAPTURE_LIMIT` | 5 | CTF captures to win |
| `TIME_LIMIT_CTF` | 600 | CTF time limit (seconds) |
| `TIME_LIMIT_FFA` | 360 | FFA time limit (seconds) |
| `FLAG_RETURN_TIMEOUT` | 20 | CTF flag auto-return timeout (seconds) |
| `FLAG_DEACTIVATED_TIME` | 3 | CTF flag deactivate time (seconds) |
| `HIT_LIMIT` | 20 | FFA hit limit |

### Server Network Settings

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `WAN_SERVER` | false | Enable public internet server |
| `FIREWALLED_SERVER` | true | Server is behind firewall |
| `IPV6_CONNECTION` | true | Enable IPv6 connections |
| `OWNER_LESS` | false | Server doesn't have an owner |
| `AI_HANDLING` | false | Enable AI player handling |
| `AI_ANYWHERE` | false | Allow AI instances to connect from outside LAN |

### Matchmaking Settings

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `KARTS_THRESHOLD` | 1 | Official karts threshold (0-1) |
| `TRACKS_THRESHOLD` | 0.7 | Official tracks threshold (0-1) |
| `AUTO_GAME_TIME_RATIO` | -1 | Auto game time ratio (-1 = disabled) |

### WAN Server Authentication

For public internet servers (`WAN_SERVER=true`), also set:

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `USERNAME` | (required) | STK account username |
| `PASSWORD` | (required) | STK account password |

### Database Settings

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `SQL_MANAGEMENT` | false | Enable SQL database for player stats |
| `DATABASE_FILE` | stkservers.db | Database filename |
| `DATABASE_TIMEOUT` | 1000 | Database timeout (milliseconds) |
| `IP_BAN_TABLE` | ip_ban | IP ban table name |
| `IPV6_BAN_TABLE` | ipv6_ban | IPv6 ban table name |
| `ONLINE_ID_BAN_TABLE` | online_id_ban | Online ID ban table name |
| `PLAYER_REPORTS_TABLE` | player_reports | Player reports table name |
| `PLAYER_REPORTS_EXPIRED_DAYS` | 3 | Days before player reports expire |
| `IP_GEOLOCATION_TABLE` | ip_mapping | IP geolocation table name |
| `IPV6_GEOLOCATION_TABLE` | ipv6_mapping | IPv6 geolocation table name |

**Note:** Do not mount over `/app` (it contains the entrypoint and app files).
If you use `SQL_MANAGEMENT=true`, mount a dedicated data path (for example `/data`) and set `DATABASE_FILE=/data/stkservers.db`.
