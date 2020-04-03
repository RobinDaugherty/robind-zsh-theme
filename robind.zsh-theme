# vim:ft=zsh ts=2 sw=2 sts=2
#
# robind's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#

CURRENT_BG='NONE'

if [[ "$AGNOSTER_LIGHT" = "1" ]]; then
 	PRIMARY_FG=white
else
 	PRIMARY_FG=black
fi


### Special Powerline characters
# Defines vars with the special prompt and Powerline characters
# Use this in conjunction with "local SEGMENT_SEPARATOR RIGHT_SEGMENT_SEPARATOR BRANCH DETACHED PLUSMINUS CROSS LIGHTNING GEAR RUBY_SYMBOL"
# in the caller to keep from leaking these into the main shell session
define_prompt_chars() {
  # Force Unicode interpretation of chars, even under odd locales
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the 
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  SEGMENT_SEPARATOR=$'\ue0b0'
  RIGHT_SEGMENT_SEPARATOR=$'\ue0b2'
  PLUSMINUS=$'\u00b1'
  BRANCH=$'\ue0a0'
  DETACHED=$'\u27a6'
  CROSS=$'\u2718'
  LIGHTNING=$'\u26a1'
  GEAR=$'\u2699'
  RUBY_SYMBOL="rb"
  NODE_SYMBOL="n"
}


### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  local SEGMENT_SEPARATOR RIGHT_SEGMENT_SEPARATOR BRANCH DETACHED PLUSMINUS CROSS LIGHTNING GEAR RUBY_SYMBOL
  define_prompt_chars
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  local SEGMENT_SEPARATOR RIGHT_SEGMENT_SEPARATOR BRANCH DETACHED PLUSMINUS CROSS LIGHTNING GEAR RUBY_SYMBOL
  define_prompt_chars
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%K%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%k"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

# Begin a segment in the Right prompt
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
right_prompt_segment() {
  local bg fg
  local SEGMENT_SEPARATOR RIGHT_SEGMENT_SEPARATOR BRANCH DETACHED PLUSMINUS CROSS LIGHTNING GEAR RUBY_SYMBOL
  define_prompt_chars
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  print -n "%F{$1}%K{$CURRENT_RIGHT_BG}$RIGHT_SEGMENT_SEPARATOR%{$fg$bg%}"
  CURRENT_RIGHT_BG=$1
  [[ -n $3 ]] && print -n $3
}


### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
    prompt_segment $PRIMARY_FG default " %(!.%{%F{yellow}%}.)$user@%M "
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local color ref mode
  local SEGMENT_SEPARATOR RIGHT_SEGMENT_SEPARATOR BRANCH DETACHED PLUSMINUS CROSS LIGHTNING GEAR RUBY_SYMBOL
  define_prompt_chars
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi

    right_prompt_segment $color $PRIMARY_FG
    print -Pn " $ref$mode "
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue $PRIMARY_FG ' %~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local SEGMENT_SEPARATOR RIGHT_SEGMENT_SEPARATOR BRANCH DETACHED PLUSMINUS CROSS LIGHTNING GEAR RUBY_SYMBOL
  define_prompt_chars
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default " $symbols "
}

# Mercurial repo status
prompt_hg() {
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        right_prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        right_prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        right_prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        right_prompt_segment red black
        st='±'
      elif `hg st | grep -q "^[MA]"`; then
        right_prompt_segment yellow black
        st='±'
      else
        right_prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    right_prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Current Ruby version
prompt_ruby() {
  local SEGMENT_SEPARATOR RIGHT_SEGMENT_SEPARATOR BRANCH DETACHED PLUSMINUS CROSS LIGHTNING GEAR RUBY_SYMBOL
  define_prompt_chars

  local ruby_version
  if [ ${RBENV_ROOT} ]; then
    ruby_version=$(rbenv version-name)
  fi
  if [ -n ${ruby_version} ] && [ "${ruby_version}" != "system" ]; then
    right_prompt_segment magenta black " ${RUBY_SYMBOL}${ruby_version} "
  fi
}

# Current Node version
prompt_node() {
  local SEGMENT_SEPARATOR RIGHT_SEGMENT_SEPARATOR BRANCH DETACHED PLUSMINUS CROSS LIGHTNING GEAR NODE_SYMBOL
  define_prompt_chars

  local node_version
  node_version=$(nodenv version-name)
  if [ $? -eq 0 ] && [ -n ${node_version} ] && [ "${node_version}" != "system" ]; then
    right_prompt_segment green black " ${NODE_SYMBOL}${node_version} "
  fi
}

prompt_time() {
  prompt_segment black white "%D{%a %f %h %Y} "
  prompt_segment white black " %D{%H:%M:%S} "
}


## Main prompt
prompt_robind_main() {
  RETVAL=$?
  local CURRENT_BG='NONE'
  # prompt_time
  prompt_status
  prompt_context
  prompt_dir
  prompt_end
}

prompt_robind_main_right() {
  prompt_git
  prompt_hg
  prompt_ruby
  prompt_node
  prompt_virtualenv
}

prompt_robind_precmd() {
  vcs_info
}

prompt_robind_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_robind_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' get-revision true
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr '✚'
  zstyle ':vcs_info:*' unstagedstr '●'
  zstyle ':vcs_info:*' formats '%b'
  zstyle ':vcs_info:*' actionformats '%b (%a)'

  setopt prompt_subst
  PROMPT='%{%f%b%k%}$(prompt_robind_main) '

  RPROMPT='%{%f%b%k%}$(prompt_robind_main_right)%{%f%b%k%}'
}

prompt_robind_setup "$@"
