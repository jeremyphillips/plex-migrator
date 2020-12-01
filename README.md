# File copy transfer
Ruby executable script to recursively copy file specific directories (defined in text file) from one server to another. Used to migrate movies to a new Plex server.

# How to use
Required gems: fileutils, yaml

Update src_dir, dest_dir and dir_list values in config.yaml file.

run `$ ./migrate_plex.rb`