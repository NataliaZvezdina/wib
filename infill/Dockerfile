FROM python:3.10-alpine
WORKDIR /opt/app
ADD ./requirements.txt .
RUN apk --update add postgresql-dev gcc python3-dev musl-dev && \
    pip install -r requirements.txt
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ADD . .
ENTRYPOINT ["python", "populate_tables.py"]