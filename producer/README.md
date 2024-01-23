
This applicaton connect to rabbitmq for produce the message.

Written in golang.

Dockerfile has two step. 

First step build the application in golang:1.19 image.

Second step runs the application in alpine:3.19.0 image.

You can build this image with your custom tag.


```bash
docker build -t "<YOUR_TAG>" .   
```

If your cpu and cluster architecture diffrent from each ohter you can build targeted platform with platform parameter.

```bash
docker build -t "<YOUR_TAG>"  --platform=linux/amd64 .
```

And push to your repo

```bash
docker push "<YOUR_TAG>"
```