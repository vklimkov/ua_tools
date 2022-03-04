
## Tools installed
* [siege_engine](https://github.com/vklimkov/siege-engine)
* [bombardier](https://github.com/codesenberg/bombardier)

## Build check and push
Had to create acc at docker hub
```
docker build --progress plain -t battle-tools -f Dockerfile ./
# to check
docker run -it --rm battle-tools
# tag
docker tag battle-tools myuatools/siege_ddos
docker login
docker push myuatools/siege_ddos
```

