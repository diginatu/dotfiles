def is_cmd_allowed(pcmd, window, from_socket, extra_data):
    cmd_name = pcmd['cmd']
    cmd_payload = pcmd['payload']

    if cmd_name != 'launch':
        return None
    args = cmd_payload.get('args')
    if args and len(args) >= 2:
        if args[0] == 'xdg-open' or args[0] == 'open':
            print('Allowing launch command:', cmd_payload)
            return True

    print('Dening launch command:', cmd_payload)
    return False
