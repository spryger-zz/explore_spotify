from SpotifyTerminal import SpotifyTerminalProcessor as SpotifyTerminal

sp = SpotifyTerminal()

thingy = sp.call_api_id('6liAMWkVf5LH7YR9yfFy1Y', 'artists')

print(thingy.json())

