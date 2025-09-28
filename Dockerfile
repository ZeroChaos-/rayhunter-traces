ARG arch="linux-x64"

FROM alpine:latest AS unpacker
ARG version="0.7.0"
ARG checksum="sha256:115ec95763fbd1314c9a540af45d51a784f95d4750e9361d1daabd7c9f189b28"
ARG arch
ADD --checksum=$checksum https://github.com/EFForg/rayhunter/releases/download/v$version/rayhunter-v$version-${arch}.zip /
RUN apk add --no-cache unzip
RUN unzip rayhunter-v$version-linux-x64.zip
RUN mv rayhunter-v$version-linux-x64 rayhunter

#FROM alpine:latest AS runner
FROM scratch AS runner
ARG arch
COPY --from=unpacker /rayhunter/rayhunter-check-${arch}/rayhunter-check /rayhunter/rayhunter-check
#COPY . /rayhunter/rayhunter-traces
WORKDIR /rayhunter
RUN ["./rayhunter-check", "--help"]
CMD ["./rayhunter-check", "-p", "rayhunter-traces"]
