def is_cmd_allowed(pcmd, window, from_socket, extra_data):
    cmd_name = pcmd['cmd']
    cmd_payload = pcmd['payload']

    print('Checking command:', cmd_name, cmd_payload)

    if cmd_name == 'run':
        args = cmd_payload.get('cmdline')
        if not args:
            return False
        if args and (len(args) <= 2):
            if args[0] == 'xdg-open' or args[0] == 'open':
                print('Allowing open command:', cmd_payload)
                return True
            if args[0] == 'remote-control-confirm':
                print('Allowing remote-control-confirm command:', cmd_payload)
                return True

    if cmd_name == 'launch':
        args = cmd_payload.get('args')
        if not args:
            return False
        if args and (len(args) == 1):
            if args[0].endswith('kitty-scrollback.nvim/python/loading.py'):
                print('Allowing launch kitty-scrollback.nvim command:', cmd_payload)
                return True

    print('Dening command:', cmd_name, cmd_payload)
    return False
