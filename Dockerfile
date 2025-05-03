FROM python:3.11-slim

WORKDIR /usr/app

# Install git and dbt-databricks
RUN apt-get update && apt-get install -y git && \
    pip install --no-cache-dir dbt-databricks==1.7.7 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["dbt"]