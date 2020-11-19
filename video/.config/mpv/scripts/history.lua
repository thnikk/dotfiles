local HISTFILE = (os.getenv('APPDATA') or os.getenv('HOME')..'/.config')..'/mpv/history.log';

mp.register_event('file-loaded', function()
    local fp;
    fp = io.open(HISTFILE, 'a+');
    fp:write(('%s\n'):format(mp.get_property('media-title')));
    fp:close();
end);
