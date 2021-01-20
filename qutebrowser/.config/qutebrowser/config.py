config.load_autoconfig()

# open yt vids with mpv
config.bind('M', 'hint --rapid links spawn mpv --speed=2 -fs {hint-url}')
# open "open" with alt+d
config.bind('<alt+d>', 'set-cmd-text -s :open ')
# open youtube subs
config.bind('<alt+y>', 'open https://youtube.com/feed/subscriptions')
c.content.user_stylesheets = '~/.config/qutebrowser/css/user.css'
