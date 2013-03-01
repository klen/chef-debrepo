Debrepo Cookbook
================

Creates a simplest debian repository. You can use it localy or remote.


Requirements
============

Platforms
---------

* Debian family

Cookbooks
---------

* nginx


Attributes
==========

* `node['debrepo']['name']` -- name of repository;
* `node['debrepo']['source_dir']` -- directory for repository;
* `node['debrepo']['nginx_proxy']` -- Enable http server;


Usage
=====

Just include `debrepo` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[debrepo]"
  ]
}
```

and edit your `/etc/apt/sources.list`

For local usage:
```
deb file:///<source_dir/ <name>/
```

For remote usage:
```
deb http://<host_name>  <name>/
```

Append package
--------------

Just copy your package to <source_dir/<name> and run <source_dir>/autorepo for rescan packages.


Contributing
============
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Authors
===================
Author: Kirill Klenov <horneds@gmail.com>
