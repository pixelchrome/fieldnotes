---
title: "Python os.path"
linkTitle: "Python os.path"
weight: 130
---

# Using `os.path.join`

Help on function join in module posixpath:

`join(a, *p)`
    Join two or more pathname components, inserting '/' as needed.
    If any component is an absolute path, all previous path components
    will be discarded.  An empty last part will result in a path that
    ends with a separator.

```python

>>> import os

>>> mypath = os.path.join("/home/administrator","test")
>>> mypath
'/home/administrator/test'

>>> mypath = os.path.join("/home/administrator","/test")
>>> mypath
'/test'

>>> mypath = os.path.join("home","administrator","test")
>>> mypath
'home/administrator/test'

>>> mypath = os.path.join("/home","administrator","test")
>>> mypath
'/home/administrator/test'

>>> help(os.path.join)
```
