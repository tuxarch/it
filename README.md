## notebook base 
# База подключается и управляется через bash-комплит


complete to .bashrc:  
```bash
g_proj_dir=~/it/man

zz()
{
    vi $g_proj_dir/$1
}

_zz()
{
    local cmd=$1 cur=$2 pre=$3
    local _cur compreply

    _cur=$g_proj_dir/$cur
    compreply=( $( compgen -f "$_cur" ) )
    COMPREPLY=( ${compreply[@]#$g_proj_dir/} )
}


complete -F _zz -o nospace zz

```

Основные положения:  
* shell.d - работа и трюки в консоли  
* command.d - простые консольные команды из coreutils 

