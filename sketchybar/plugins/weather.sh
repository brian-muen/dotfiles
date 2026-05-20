#!/bin/bash

# Wait for internet connection
for i in {1..30}; do
    if ping -c 1 8.8.8.8 &> /dev/null; then
        break
    fi
    sleep 2
done

ENV_FILE="$(dirname "$0")/../sketchybar_env"
if [ ! -f "$ENV_FILE" ]; then
  sketchybar --set weather icon="􁜏" label="--"
  exit 0
fi

source "$ENV_FILE"
if [ -z "$API_KEY" ]; then
  sketchybar --set weather icon="􁜏" label="--"
  exit 0
fi
LOCATION_DATA=$(curl -sf "http://ip-api.com/json")
LAT=$(echo "$LOCATION_DATA" | jq -r '.lat')
LON=$(echo "$LOCATION_DATA" | jq -r '.lon')
URL="https://api.openweathermap.org/data/2.5/weather?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=metric"

DATA=$(curl -sf "$URL")
if [ -z "$DATA" ]; then
  sketchybar --set weather icon="􁜏" label="--"
  exit 1
fi

TEMP=$(echo "$DATA" | jq '.main.temp' | cut -d "." -f 1)
CONDITION=$(echo "$DATA" | jq -r '.weather[0].main')
CONDITION_DESC=$(echo "$DATA" | jq -r '.weather[0].description')

case "$CONDITION_DESC" in
  "few clouds") ICON="􀇕" ;;
  *)
    case "$CONDITION" in
      Thunderstorm) ICON="􀇟" ;;
      Drizzle)      ICON="􀇅" ;;
      Rain)         ICON="􀇇" ;;
      Snow)         ICON="􀇏" ;;
      Clear)        ICON="􀆮" ;;
      Clouds)       ICON="􀇃" ;;
      Mist|Fog|Haze|Smoke|Dust|Ash|Sand) ICON="􀇣" ;;
      *)            ICON="􀁝" ;;
    esac
    ;;
esac

sketchybar --animate tanh 10 --set weather icon="$ICON" label="${TEMP}°C"
