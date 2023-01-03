import os
import json
import boto3
import requests
from bs4 import BeautifulSoup

from src.models import Ticker, VUSA, NVDA


def get_model(marker: str):
    if marker == 'VUSA':
        return VUSA()
    elif marker == 'NVDA':
        return NVDA()
    else:
        raise ValueError(f'Marker {marker} not recognized')


def requester(model):
    r = requests.get(url="https://uk.finance.yahoo.com/quote/VUSA.L?p=VUSA.L", headers=model.headers)
    html_text = BeautifulSoup(r.text, features='html.parser')
    print(html_text)

    raw_text = html_text.find('ul', attrs={"class": "mod-tearsheet-overview__quote__bar"})
    raw_data = raw_text.text.strip().replace('\n', ':').split(':')

    return raw_data


def raw_transform(model, raw_data: list):
    if model.parser == 'uk_investing':
        model.parse(raw_data=raw_data)


def save_data_s3(model: Ticker):
    client = boto3.client('s3')

    # Get the file if exists else create it.
    try:
        obj = client.get_object(Bucket=model.s3_bucket, Key=model.s3_key)
        upload_data = json.loads(obj['Body'].read())
    except:
        upload_data = []

    upload_data.append(model.data.__dict__)
    client.put_object(Body=json.dumps(upload_data), Bucket=model.s3_bucket, Key=model.s3_key)


def lambda_handler(event, context):
    marker = event['ticker']
    model = get_model(marker)
    model.debug = True if os.getenv('env') else False

    # Extract
    raw_data = requester(model)

    # Transform
    raw_transform(model, raw_data=raw_data)

    # Load
    # save_data_s3(model=model)
    return model


if __name__ == '__main__':
    result = lambda_handler(
        event={"ticker": "VUSA"},
        context=None
    )

    print(result)
