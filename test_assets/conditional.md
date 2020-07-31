# Conditional

[//]: #conditional ([[ "$OSTYPE" == "linux-gnu" ]])
```bash ignore
echo "Only on linux-gnu"
```

Using multiple conditionals, the basic pre / post condition module.

[//]: #pre (echo Before Block)
[//]: #post (echo After Block)
[//]: #post (echo After Block 2)
[//]: #pre (echo Before Block 2)
```bash
echo "between block"
```

Using conditionals in bash format to check external environment variables

[//]: #conditional ([[ "$EXTERNAL_ENV" == "linux-gnu" ]])
```bash
echo $EXTERNAL_ENV is linux-gnu
```

[//]: #conditional ([[ "$EXTERNAL_ENV" == "linux-gnu" ]])
[//]: #conditional ([[ "$EXTERNAL_ENV" == "not-linux-gnu" ]])
```bash
echo $EXTERNAL_ENV is not linux-gnu
```

[//]: #arg1 (version)
[//]: #arg2 ( )
```bash
echo "show version"
```

Using multiple arguments, the order does not matter

[//]: #arg1 (version)
[//]: #arg2 (all)
```bash
echo "show all versions"
```

[//]: #arg2 (all)
[//]: #arg1 (version)
```bash
echo "show all versions"
```

[//]: #arg1 (version)
[//]: #arg2 (no)
```bash
echo "show no versions"
```

[//]: #arg2 (no)
[//]: #arg1 (version)
```bash
echo "show no versions"
```
