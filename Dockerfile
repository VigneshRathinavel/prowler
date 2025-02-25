FROM python:3.9-alpine

LABEL maintainer="https://github.com/prowler-cloud/prowler"

# Update system dependencies
RUN apk --no-cache update && apk --no-cache upgrade

# Create nonroot user
RUN mkdir -p /home/prowler && \
    echo 'prowler:x:1000:1000:prowler:/home/prowler:' > /etc/passwd && \
    echo 'prowler:x:1000:' > /etc/group && \
    chown -R prowler:prowler /home/prowler
USER prowler

# Copy necessary files
WORKDIR /home/prowler
COPY prowler/ /home/prowler/prowler/
COPY pyproject.toml /home/prowler

# Install dependencies
ENV HOME='/home/prowler'
ENV PATH="$HOME/.local/bin:$PATH"
#hadolint ignore=DL3013
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .

ENTRYPOINT ["prowler"]
