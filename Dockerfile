FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y chocolate-doom freedoom xvfb fluxbox x11vnc novnc websockify x11-utils xfonts-base && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=:99
ENV DOOMWADDIR=/usr/share/games/doom
ENV PATH="$PATH:/usr/games"

EXPOSE 5900 6080

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
