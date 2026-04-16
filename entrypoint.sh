#!/bin/bash

set -e

CONFIG_FILE="/app/config/server-config.xml"

if [ -f /app/config.xml ]; then
    CONFIG_FILE="/app/config.xml"
elif [ -f /app/config/server-config.xml ]; then
    CONFIG_FILE="/app/config/server-config.xml"
fi

generate_config() {
    cat <<EOF
<?xml version="1.0"?>
<server-config version="6" >
    <server-name value="${SERVER_NAME:-STK Server}" />
    <server-port value="${SERVER_PORT:-2759}" />
    <server-mode value="${SERVER_MODE:-3}" />
    <server-difficulty value="${SERVER_DIFFICULTY:-0}" />
    <gp-track-count value="${GP_TRACK_COUNT:-3}" />
    <soccer-goal-target value="${SOCCER_GOAL_TARGET:-false}" />
    <wan-server value="${WAN_SERVER:-false}" />
    <enable-console value="${ENABLE_CONSOLE:-false}" />
    <server-max-players value="${MAX_PLAYERS:-8}" />
    <private-server-password value="${SERVER_PASSWORD:-}" />
    <motd value="${MOTD:-}" />
    <chat value="${CHAT:-true}" />
    <chat-consecutive-interval value="${CHAT_CONSECUTIVE_INTERVAL:-8}" />
    <track-voting value="${TRACK_VOTING:-true}" />
    <voting-timeout value="${VOTING_TIMEOUT:-30}" />
    <validation-timeout value="${VALIDATION_TIMEOUT:-20}" />
    <validating-player value="${VALIDATING_PLAYER:-true}" />
    <firewalled-server value="${FIREWALLED_SERVER:-true}" />
    <ipv6-connection value="${IPV6_CONNECTION:-true}" />
    <owner-less value="${OWNER_LESS:-false}" />
    <start-game-counter value="${START_GAME_COUNTER:-60}" />
    <official-karts-threshold value="${KARTS_THRESHOLD:-1}" />
    <official-tracks-threshold value="${TRACKS_THRESHOLD:-0.7}" />
    <min-start-game-players value="${MIN_START_PLAYERS:-2}" />
    <auto-end value="${AUTO_END:-false}" />
    <team-choosing value="${TEAM_CHOOSING:-true}" />
    <strict-players value="${STRICT_PLAYERS:-false}" />
    <ranked value="${RANKED:-false}" />
    <server-configurable value="${SERVER_CONFIGURABLE:-false}" />
    <live-players value="${LIVE_PLAYERS:-true}" />
    <flag-return-timeout value="${FLAG_RETURN_TIMEOUT:-20}" />
    <flag-deactivated-time value="${FLAG_DEACTIVATED_TIME:-3}" />
    <hit-limit value="${HIT_LIMIT:-20}" />
    <time-limit-ffa value="${TIME_LIMIT_FFA:-360}" />
    <capture-limit value="${CAPTURE_LIMIT:-5}" />
    <time-limit-ctf value="${TIME_LIMIT_CTF:-600}" />
    <auto-game-time-ratio value="${AUTO_GAME_TIME_RATIO:--1}" />
    <max-ping value="${MAX_PING:-300}" />
    <jitter-tolerance value="${JITTER_TOLERANCE:-100}" />
    <kick-high-ping-players value="${KICK_HIGH_PING:-false}" />
    <high-ping-workaround value="${HIGH_PING_WORKAROUND:-true}" />
    <kick-idle-player-seconds value="${KICK_IDLE_SECONDS:-60}" />
    <state-frequency value="${STATE_FREQUENCY:-10}" />
    <sql-management value="${SQL_MANAGEMENT:-false}" />
    <database-file value="stkservers.db" />
    <database-timeout value="1000" />
    <ip-ban-table value="" />
    <ipv6-ban-table value="" />
    <online-id-ban-table value="" />
    <player-reports-table value="" />
    <player-reports-expired-days value="3" />
    <ip-geolocation-table value="" />
    <ipv6-geolocation-table value="" />
    <ai-handling value="${AI_HANDLING:-false}" />
</server-config>
EOF
}

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
    supertuxkart --init-user --login="$USERNAME" --password="$PASSWORD"
fi

if [ -f /app/config.xml ]; then
    cp /app/config.xml "$CONFIG_FILE"
elif [ -f /app/config/server-config.xml ]; then
    cp /app/config/server-config.xml "$CONFIG_FILE"
else
    generate_config > "$CONFIG_FILE"
fi

exec supertuxkart --server-config="$CONFIG_FILE" --no-graphics --lan-server="${LAN_SERVER_NAME:-${SERVER_NAME:-STK Server}}"
