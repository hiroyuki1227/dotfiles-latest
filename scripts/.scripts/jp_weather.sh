##!/bin/bash
# 神奈川県座間市向け天気スクリプト
# データソース: Open-Meteo API (BrightSky と同等の無料・登録不要)

# --- 座間市の座標 ---
LATITUDE=35.4833
LONGITUDE=139.4000

# --- 現在日時を取得（JSTで今日の日付）---
current_date=$(date +"%Y-%m-%d")

# --- 現在の分を取得して「直近の正時」を決定（元スクリプトと同ロジック）---
current_minute=$(date +"%M")
if [ "$current_minute" -le 30 ]; then
  correct_hour=$(date +"%Y-%m-%dT%H:00")
else
  correct_hour=$(date -r $(($(date +%s) + 3600)) +"%Y-%m-%dT%H:00")
fi

# --- Open-Meteo API から1時間ごとのデータを取得 ---
weather_data=$(curl -s \
  "https://api.open-meteo.com/v1/forecast\
?latitude=${LATITUDE}\
&longitude=${LONGITUDE}\
&hourly=temperature_2m,weather_code,wind_speed_10m,cloud_cover,visibility\
&wind_speed_unit=kmh\
&timezone=Asia%2FTokyo\
&start_date=${current_date}\
&end_date=${current_date}")

# --- correct_hour に一致するインデックスを特定して各値を抽出 ---
idx=$(echo "$weather_data" | jq -r --arg t "$correct_hour" \
  '.hourly.time | to_entries[] | select(.value == $t) | .key')

temperature=$(echo "$weather_data" | jq -r --argjson i "$idx" '.hourly.temperature_2m[$i]')
weather_code=$(echo "$weather_data" | jq -r --argjson i "$idx" '.hourly.weather_code[$i]')
wind_speed=$(echo "$weather_data" | jq -r --argjson i "$idx" '.hourly.wind_speed_10m[$i]')
cloud_cover=$(echo "$weather_data" | jq -r --argjson i "$idx" '.hourly.cloud_cover[$i]')
visibility=$(echo "$weather_data" | jq -r --argjson i "$idx" '.hourly.visibility[$i]')

# --- WMO Weather Code → condition / icon 変換（Lua weather.lua のキーに準拠）---
get_condition_and_icon() {
  local code=$1
  case $code in
  0) echo "clear-day|clear-day" ;;
  1 | 2) echo "partly-cloudy-day|partly-cloudy-day" ;;
  3) echo "cloudy|cloudy" ;;
  45 | 48) echo "fog|fog" ;;
  51 | 53 | 55) echo "rain|rain" ;;
  56 | 57) echo "sleet|sleet" ;;
  61 | 63 | 65) echo "rain|rain" ;;
  66 | 67) echo "sleet|sleet" ;;
  71 | 73 | 75 | 77) echo "snow|snow" ;;
  80 | 81 | 82) echo "rain|rain" ;;
  85 | 86) echo "snow|snow" ;;
  95) echo "thunderstorm|thunderstorm" ;;
  96 | 99) echo "thunderstorm|thunderstorm" ;;
  *) echo "cloudy|cloudy" ;;
  esac
}

mapping=$(get_condition_and_icon "$weather_code")
condition="${mapping%%|*}"
icon="${mapping##*|}"

# --- 夜間判定（19時〜6時）---
current_hour=$(date +"%H")
if [ "$current_hour" -ge 19 ] || [ "$current_hour" -lt 6 ]; then
  [ "$icon" = "clear-day" ] && icon="clear-night" && condition="clear-night"
  [ "$icon" = "partly-cloudy-day" ] && icon="partly-cloudy-night" && condition="partly-cloudy-night"
fi

# --- 結果出力（Lua weather.lua が期待するフォーマット）---
# visibility はメートル数値のみ（km換算はLua側）
# wind_speed / cloud_cover も数値のみ（単位はLua側）
echo "Station Name: 座間市, 神奈川"
echo "Condition: ${condition}"
echo "Icon: ${icon}"
echo "Temperature: ${temperature}°C"
echo "Wind Speed: ${wind_speed}"
echo "Cloud Cover: ${cloud_cover}"
echo "Visibility: ${visibility}"

##!/bin/bash
#
## Aktuelles Datum bestimmen
#current_date=$(date -u +"%Y-%m-%d")
#
## Wetterdaten von der API abrufen
#weather_data=$(curl -s "https://api.brightsky.dev/weather?lat=50.801&lon=12.7133&date=${current_date}")
#
## Aktuelle Zeit in UTC bestimmen
#current_time=$(date -u +"%Y-%m-%dT%H:%M:%S%z")
#current_minute=$(date -u +"%M")
#
## Berechne die richtige volle Stunde basierend auf der aktuellen Minute
#if [ "$current_minute" -le 30 ]; then
#  correct_hour=$(date -u +"%Y-%m-%dT%H:00:00+00:00")
#else
#  correct_hour=$(date -u -r $(($(date -u +%s) + 3600)) +"%Y-%m-%dT%H:00:00+00:00")
#fi
#
## Daten extrahieren
#temperature=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
#    .weather[] | select(.timestamp == $correct_hour) | .temperature')
#icon=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
#    .weather[] | select(.timestamp == $correct_hour) | .icon')
#condition=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
#    .weather[] | select(.timestamp == $correct_hour) | .condition')
#wind_speed=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
#    .weather[] | select(.timestamp == $correct_hour) | .wind_speed')
#cloud_cover=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
#    .weather[] | select(.timestamp == $correct_hour) | .cloud_cover')
#visibility=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
#    .weather[] | select(.timestamp == $correct_hour) | .visibility')
#
## Ergebnisse auf separaten Zeilen ausgeben
#echo "Station Name: St. Egdidien/Kuhschnappel"
#echo "Condition: ${condition}"
#echo "Icon: ${icon}"
#echo "Temperature: ${temperature}°C"
#echo "Wind Speed: ${wind_speed}"
#echo "Cloud Cover: ${cloud_cover}"
#echo "Visibility: ${visibility}"
