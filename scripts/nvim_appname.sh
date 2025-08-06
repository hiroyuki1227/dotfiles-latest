#! /bin/sh

if command -v nvim &> /dev/null; then
  # NVIM_APPNAME
  if [ ! -f ${XDG_STATE_HOME}/nvim_appname ]; then
    echo nvim > ${XDG_STATE_HOME}/nvim_appname
  fi
  if [ -f ${XDG_STATE_HOME}/nvim_appname ]; then
    declare -x NVIM_APPNAME=$(cat ${XDG_STATE_HOME}/nvim_appname)
  fi

  nvim_appnames=(
      nvim
      astronvim
      nvchad
      lunarvim
    )
    function nvim_appname() {
      switch_nvim_appname=$(gum choose --select-if-one --header "current NVIM_APPNAME: ${NVIM_APPNAME}" ${nvim_appnames[@]})
      if [ -n "${switch_nvim_appname}" ]; then
        echo ${switch_nvim_appname} > ${XDG_STATE_HOME}/nvim_appname
        export NVIM_APPNAME=$(cat ${XDG_STATE_HOME}/nvim_appname)
        echo "switch NVIM_APPNAME: ${switch_nvim_appname}"
      fi
      echo "output NVIM_APPNAME: ${NVIM_APPNAME}"
    }
  function vi(){
   #  nvim -c "LetItSnow" "$@"
    nvim "$@"
  }
  function vim(){
    nvim "$@"
  }
fi
