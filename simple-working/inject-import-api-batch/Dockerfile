FROM python:3.8
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY noauth-batch-create-refresco.py /code
WORKDIR /code
