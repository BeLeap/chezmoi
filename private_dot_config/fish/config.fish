if status is-interactive
    fish_vi_key_bindings

    set -x EDITOR hx

    alias sofish "source ~/.config/fish/config.fish"
    alias docker podman

    alias e "$EDITOR"

    abbr gst "git status"
    abbr gsw "git switch"
    abbr gd "git diff"
    abbr ga "git add"
    abbr gc "git commit -v"
    abbr gac "git commit -av"
    abbr gp "git push"
    abbr gf "git fetch --prune --all"
    abbr gl "git pull"
    abbr gco "git checkout"
    abbr glp "git pull --rebase && git push"

    abbr k kubectl
    abbr ktx kubectx
    abbr kns kubens

    abbr prmd "gh pr merge -d"
    abbr prvw "gh pr view -w"
    abbr prv "gh pr view"
    abbr prcm "gh pr create --assignee @me"

    abbr tf terraform

    if type -q starship
        starship init fish | source
    end
    if type -q zoxide
        zoxide init fish | source
    end
    if type -q lsd
        alias ls "lsd --group-directories-first"
        alias ll "lsd --group-directories-first -l"
        alias lla "lsd --group-directories-first -la"
    end

    if type -q nodenv
        source (nodenv init -|psub)
    end

    if type -q direnv
        direnv hook fish | source
    end

    if type -q carapace
        carapace _carapace | source
    end

    if type -q rbenv
        status --is-interactive; and rbenv init - fish | source
    end

    if type -q fzf
        fzf --fish | source
    end

    if type -q pyenv
        status --is-interactive; and pyenv init - | source
    end
end
