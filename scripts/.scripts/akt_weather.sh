#!/bin/bash
# 現在の日時を取得（東京時間）
current_date=$(date +"%Y-%m-%d")

# Open-Meteo API から東京の天気データを取得
# - latitude/longitude: 東京
# - current: 現在の気象データ
# - wind_speed_10m_unit: km/h (元スクリプトに合わせる)
# - timezone: Asia/Tokyo (時刻をJSTで返す)
weather_data=$(curl -s \
  "https://api.open-meteo.com/v1/forecast\
?latitude=35.6895\
&longitude=139.6917\
&current=temperature_2m,weather_code,wind_speed_10m,cloud_cover,visibility\
&wind_speed_unit=kmh\
&timezone=Asia%2FTokyo")

# 各フィールドを抽出
temperature=$(echo "$weather_data" | jq -r '.current.temperature_2m')
weather_code=$(echo "$weather_data" | jq -r '.current.weather_code')
wind_speed=$(echo "$weather_data" | jq -r '.current.wind_speed_10m')
cloud_cover=$(echo "$weather_data" | jq -r '.current.cloud_cover')
visibility=$(echo "$weather_data" | jq -r '.current.visibility')
current_time=$(echo "$weather_data" | jq -r '.current.time')

# ---------------------------------------------------------------------------
# WMO Weather Code → condition / icon に変換
# (BrightSky の condition/icon に相当するマッピング)
# https://open-meteo.com/en/docs#weathervariables
# ---------------------------------------------------------------------------
get_condition_and_icon() {
  local code=$1
  case $code in
  0) echo "clear-day|clear-day" ;;
  1) echo "mostly-clear|partly-cloudy-day" ;;
  2) echo "partly-cloudy|partly-cloudy-day" ;;
  3) echo "overcast|cloudy" ;;
  45 | 48) echo "fog|fog" ;;
  51 | 53 | 55) echo "drizzle|rain" ;;
  56 | 57) echo "freezing-drizzle|sleet" ;;
  61 | 63 | 65) echo "rain|rain" ;;
  66 | 67) echo "freezing-rain|sleet" ;;
  71 | 73 | 75 | 77) echo "snow|snow" ;;
  80 | 81 | 82) echo "rain-showers|rain" ;;
  85 | 86) echo "snow-showers|snow" ;;
  95) echo "thunderstorm|thunderstorm" ;;
  96 | 99) echo "thunderstorm-hail|thunderstorm" ;;
  *) echo "unknown|unknown" ;;
  esac
}

mapping=$(get_condition_and_icon "$weather_code")
condition="${mapping%%|*}"
icon="${mapping##*|}"

# 視程をメートル→キロメートルに変換して表示
visibility_km=$(echo "$visibility" | awk '{printf "%.1f km", $1 / 1000}')

# ---------------------------------------------------------------------------
# 結果を出力（元スクリプトのフォーマットに合わせる）
# ---------------------------------------------------------------------------
echo "Station Name: Tokyo, Japan"
echo "Condition: ${condition}"
echo "Icon: ${icon}"
echo "Temperature: ${temperature}°C"
echo "Wind Speed: ${wind_speed} km/h"
echo "Cloud Cover: ${cloud_cover}%"
echo "Visibility: ${visibility_km}"
echo "Time: ${current_time} JST"
