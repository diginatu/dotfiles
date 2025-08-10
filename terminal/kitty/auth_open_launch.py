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

    print('Dening command:', cmd_name, cmd_payload)
    return False
