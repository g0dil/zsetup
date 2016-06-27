
case "$(ssh-add -l 2>/dev/null | awk '{print $2}')" in
2a:84:7b:b4:62:5d:95:9f:33:10:d0:5f:6c:91:0a:62) exec zsh ;;
*) ;;
esac

