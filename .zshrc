export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

alias ls="eza --icons=always"
eval "$(zoxide init zsh)"

alias cd="z"

HAS_WIDECHARS="false"
# Source manjaro-zsh-configuration
# if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
#   source /usr/share/zsh/manjaro-zsh-config
# fi
#
# Use manjaro zsh prompt
# if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
#   source /usr/share/zsh/manjaro-zsh-prompt
# fi
#

source $ZSH/oh-my-zsh.sh
source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

plugins=(git zsh-autosuggestions dotenv direnv)
prompt_context() {} 

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

export PATH=$PATH:$HOME/binaries/go/bin
export PATH=$PATH:/$HOME/binaries/flutter/bin
export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH=$PATH:/$HOME/binaries/go-migrate
export PATH="$PATH:/$HOME/.local/kitty.app/bin"

export GOPATH=$HOME/go
# export GOROOT=$PATH:$HOME/binaries/go

# export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export ANDROID_HOME=$PATH:/home/mujheri/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:/home/mujheri/go/bin


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mujheri/binaries/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mujheri/binaries/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mujheri/binaries/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mujheri/binaries/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(direnv hook zsh)"

