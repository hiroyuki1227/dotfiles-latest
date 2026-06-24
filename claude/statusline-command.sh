#!/bin/bash
# Claude Code Powerline-style status line — minimal with subtle accents
# Requires a Nerd Font (e.g. MesloLGS NF, FiraCode Nerd Font) for glyph rendering.
input=$(cat)

# ---------------------------------------------------------------------------
# Extract all JSON fields in a single jq invocation
# ---------------------------------------------------------------------------
{
  read -r model
  read -r cwd
  read -r used_pct
  read -r five_hour_pct
  read -r five_hour_reset
  read -r seven_day_pct
} <<_JQ_
$(printf '%s' "$input" | jq -r '
  (.model.display_name // "Claude"),
  (.workspace.current_dir // .cwd // ""),
  (.context_window.used_percentage // ""),
  (.rate_limits.five_hour.used_percentage // ""),
  (.rate_limits.five_hour.resets_at // ""),
  (.rate_limits.seven_day.used_percentage // "")')
_JQ_

# Git branch — skip when cwd is unknown (avoids git -C "" using process CWD)
branch=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

# Shorten path using literal parameter expansion (no regex — safe with dots in $HOME)
case "$cwd" in
"$HOME"/*) short_cwd="~/${cwd#"$HOME"/}" ;;
"$HOME") short_cwd="~" ;;
*) short_cwd="$cwd" ;;
esac

# ---------------------------------------------------------------------------
# Palette — mostly grey, two muted accents (neovim-style)
#   Accent 1: soft teal  (66)  — context bar
#   Accent 2: soft sage  (65)  — git branch
# ---------------------------------------------------------------------------
R1_A_BG=238
R1_A_FG=252 # dark grey / near-white  (model segment)
R1_B_BG=66
R1_B_FG=194 # muted teal bg / pale mint text  (context segment)

R2_A_BG=65
R2_A_FG=194 # muted sage bg / pale green text  (branch segment)
R2_B_BG=234
R2_B_FG=242 # very dark / dim grey  (week limit segment)
R2_C_BG=237
R2_C_FG=252 # dark grey / near-white  (path segment)

# Powerline separator glyphs (Nerd Font codepoints)
SEP_RIGHT='' # U+E0B0 solid right arrow

# Pre-compute ANSI escape sequences once to avoid subshells during output
_bg_r1a=$(printf '\033[48;5;%sm' "$R1_A_BG")
_fg_r1a=$(printf '\033[38;5;%sm' "$R1_A_FG")
_bg_r1b=$(printf '\033[48;5;%sm' "$R1_B_BG")
_fg_r1b=$(printf '\033[38;5;%sm' "$R1_B_FG")
_bg_r2a=$(printf '\033[48;5;%sm' "$R2_A_BG")
_fg_r2a=$(printf '\033[38;5;%sm' "$R2_A_FG")
_bg_r2b=$(printf '\033[48;5;%sm' "$R2_B_BG")
_fg_r2b=$(printf '\033[38;5;%sm' "$R2_B_FG")
_bg_r2c=$(printf '\033[48;5;%sm' "$R2_C_BG")
_fg_r2c=$(printf '\033[38;5;%sm' "$R2_C_FG")
_sep_r1_12=$(printf '\033[48;5;%sm\033[38;5;%sm' "$R1_B_BG" "$R1_A_BG")
_sep_r1_23=$(printf '\033[48;5;%sm\033[38;5;%sm' "$R1_A_BG" "$R1_B_BG")
_sep_r1_end=$(printf '\033[38;5;%sm' "$R1_A_BG")
_sep_r2_12=$(printf '\033[48;5;%sm\033[38;5;%sm' "$R2_B_BG" "$R2_A_BG")
_sep_r2_23=$(printf '\033[48;5;%sm\033[38;5;%sm' "$R2_C_BG" "$R2_B_BG")
_sep_r2_end=$(printf '\033[38;5;%sm' "$R2_C_BG")
_rst=$(printf '\033[0m')

# ---------------------------------------------------------------------------
# Progress-bar builder (width=12 cells)
# ---------------------------------------------------------------------------
make_bar() {
  _mb_pct="$1"
  _mb_width=12
  _mb_int=$(printf '%.0f' "$_mb_pct")
  _mb_filled=$((_mb_int * _mb_width / 100))
  [ $_mb_filled -gt $_mb_width ] && _mb_filled=$_mb_width
  _mb_empty=$((_mb_width - _mb_filled))
  _mb_bar=""
  _mb_i=0
  while [ $_mb_i -lt $_mb_filled ]; do
    _mb_bar="${_mb_bar}█"
    _mb_i=$((_mb_i + 1))
  done
  _mb_i=0
  while [ $_mb_i -lt $_mb_empty ]; do
    _mb_bar="${_mb_bar}░"
    _mb_i=$((_mb_i + 1))
  done
  printf "%s %d%%" "$_mb_bar" "$_mb_int"
}

# ---------------------------------------------------------------------------
# Compute remaining time on 5-hour block
# ---------------------------------------------------------------------------
block_timer=""
case "$five_hour_reset" in
'' | *[!0-9]*) five_hour_reset="" ;;
esac
if [ -n "$five_hour_reset" ]; then
  now=$(date +%s)
  remaining=$((five_hour_reset - now))
  if [ $remaining -gt 0 ]; then
    mins=$((remaining / 60))
    hrs=$((mins / 60))
    mins=$((mins % 60))
    if [ $hrs -gt 0 ]; then
      block_timer=$(printf "%dh%02dm" "$hrs" "$mins")
    else
      block_timer=$(printf "%dm" "$mins")
    fi
  else
    block_timer="resetting"
  fi
fi

# ---------------------------------------------------------------------------
# ROW 1:  Model | Context | Block/Rate bar
# ---------------------------------------------------------------------------
printf "%s %s %s" "${_bg_r1a}${_fg_r1a}" "${model}" "${_rst}"
printf "%s%s%s" "${_sep_r1_12}" "$SEP_RIGHT" "${_rst}"

if [ -n "$used_pct" ]; then
  ctx_bar=$(make_bar "$used_pct")
  ctx_text=" ctx: ${ctx_bar} "
else
  ctx_text=" ctx: --- "
fi
printf "%s%s%s" "${_bg_r1b}${_fg_r1b}" "$ctx_text" "${_rst}"
printf "%s%s%s" "${_sep_r1_23}" "$SEP_RIGHT" "${_rst}"

if [ -n "$five_hour_pct" ]; then
  rate_bar=$(make_bar "$five_hour_pct")
  if [ -n "$block_timer" ]; then
    rate_text=" 5h: ${rate_bar}  ${block_timer} "
  else
    rate_text=" 5h: ${rate_bar} "
  fi
else
  if [ -n "$block_timer" ]; then
    rate_text="  ${block_timer} "
  else
    rate_text=" rate: --- "
  fi
fi
printf "%s%s%s" "${_bg_r1a}${_fg_r1a}" "$rate_text" "${_rst}"
printf "%s%s%s\n" "${_sep_r1_end}" "$SEP_RIGHT" "${_rst}"

# ---------------------------------------------------------------------------
# ROW 2:  Git Branch | Pro Week Limit | Path
# ---------------------------------------------------------------------------
if [ -n "$branch" ] && [ "$branch" != "HEAD" ]; then
  branch_text="  ${branch} "
elif [ "$branch" = "HEAD" ]; then
  branch_text="  detached "
else
  branch_text="  no git "
fi
printf "%s%s%s" "${_bg_r2a}${_fg_r2a}" "$branch_text" "${_rst}"
printf "%s%s%s" "${_sep_r2_12}" "$SEP_RIGHT" "${_rst}"

if [ -n "$seven_day_pct" ]; then
  week_bar=$(make_bar "$seven_day_pct")
  week_inner=" Pro Week: ${week_bar} "
else
  week_inner=" Pro Week: --- "
fi
printf "%s%s%s" "${_bg_r2b}${_fg_r2b}" "$week_inner" "${_rst}"
printf "%s%s%s" "${_sep_r2_23}" "$SEP_RIGHT" "${_rst}"

printf "%s  %s %s" "${_bg_r2c}${_fg_r2c}" "$short_cwd" "${_rst}"
printf "%s%s%s\n" "${_sep_r2_end}" "$SEP_RIGHT" "${_rst}"
