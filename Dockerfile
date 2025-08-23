FROM alpine:latest AS unpacker
ARG version="0.6.0"
ARG checksum="sha256:270b11565a70de374144b88a5f0df16c61414bcb3ce36bc7d7eb150780ecff4a"
ADD --checksum=$checksum https://github.com/EFForg/rayhunter/releases/download/v$version/rayhunter-v$version-linux-x64.zip /
RUN apk add --no-cache unzip
RUN unzip rayhunter-v$version-linux-x64.zip
RUN mv rayhunter-v$version-linux-x64 rayhunter

FROM alpine:latest AS runner
COPY --from=unpacker /rayhunter /rayhunter
COPY . /rayhunter/rayhunter-traces
WORKDIR /rayhunter
CMD ["rayhunter-check -p rayhunter-traces"]
