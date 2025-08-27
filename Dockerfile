ARG arch="linux-x64"

FROM alpine:latest AS unpacker
ARG version="0.6.1"
ARG checksum="sha256:0fbbd518c0606b1a233127c110fba3de62d1502e4cb9eeccdd5624c83bd31d62"
ARG arch
ADD --checksum=$checksum https://github.com/EFForg/rayhunter/releases/download/v$version/rayhunter-v$version-${arch}.zip /
RUN apk add --no-cache unzip
RUN unzip rayhunter-v$version-linux-x64.zip
RUN mv rayhunter-v$version-linux-x64 rayhunter

#FROM alpine:latest AS runner
FROM scratch AS runner
ARG arch
COPY --from=unpacker /rayhunter/rayhunter-check-${arch}/rayhunter-check /rayhunter/rayhunter-check
COPY . /rayhunter/rayhunter-traces
WORKDIR /rayhunter
RUN ["./rayhunter-check", "--help"]
RUN ["./rayhunter-check", "-p", "rayhunter-traces"]
