FROM python:3.9-slim

COPY . /app

ENV LISTEN_PORT=5000
EXPOSE 5000

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install psycopg2
    

CMD ["python", "app.py"]
