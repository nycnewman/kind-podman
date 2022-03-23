# Docker Auth config

# Format of Docker config.json credential file

```
{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "auth_key",
            "email": "email@domain"
        }
    }
}
```

Use the following command to produce the base64 of your credentials
```
echo -n 'username:password' | base64
```


