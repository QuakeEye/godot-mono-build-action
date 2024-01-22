FROM barichello/godot-ci:mono-latest

# Install dotnet sdk
RUN apt-get update
RUN apt-get install -y wget
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
RUN chmod +x ./dotnet-install.sh
RUN ./dotnet-install.sh --version latest

# Add dotnet to path
ENV PATH="/root/.dotnet:${PATH}"
ENV DOTNET_ROOT="/root/.dotnet"

LABEL "com.github.actions.name"="Build Godot Mono"
LABEL "com.github.actions.description"="Build a Godot mono project"
LABEL "com.github.actions.icon"="play-circle"
LABEL "com.github.actions.color"="purple"

LABEL repository="https://github.com/QuakeEye/godot-mono-build-action"

USER root
ADD entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]