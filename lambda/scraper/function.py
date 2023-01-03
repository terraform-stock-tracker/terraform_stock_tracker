import datetime
import json
import boto3
import re
import requests
from dataclasses import dataclass
from bs4 import BeautifulSoup


@dataclass
class VUSA:
    data: dict
    updated_at: str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    price: float = None
    change: float = None
    change_percent: float = None
    previous_close: float = None
    open_value: float = None
    bid_value: str = None
    ask_value: str = None
    day_min_value: float = None
    day_max_value: float = None
    year_min_value: float = None
    year_max_value: float = None
    volume: int = None
    avg_3_month_volume: int = None
    net_assets: str = None
    nav: float = None
    pe_ratio: float = None
    yield_value: float = None
    ytd_daily_total_return: float = None
    beta_5_year_monthly: float = None
    net_expense_ratio: float = None
    inception_date: float = None

    def __post_init__(self):
        self.price = self._get_value("price", float)
        self.change = self._get_value("change", float, from_tag=True)
        self.change_percent = self._get_value("change_percent", float, from_tag=True)
        self.previous_close = self._get_value("previous_close", float)
        self.open_value = self._get_value("open_value", float)
        self.bid_value = self._get_value("bid_value", str)
        self.ask_value = self._get_value("ask_value", str)
        self.day_min_value = float(self._get_value('days_range_value', str).split(' - ')[0]) if self._get_value('days_range_value', str) else None
        self.day_max_value = float(self._get_value('days_range_value', str).split(' - ')[1]) if self._get_value('days_range_value', str) else None
        self.year_min_value = float(self._get_value('year_week_range_value', str).split(' - ')[0]) if self._get_value('year_week_range_value', str) else None
        self.year_max_value = float(self._get_value('year_week_range_value', str).split(' - ')[1]) if self._get_value('year_week_range_value', str) else None
        self.volume = self._get_value("volume_value", float)
        self.avg_3_month_volume = self._get_value("avg_3_month_volume", float)
        self.net_assets = self._get_value("net_assets_value", str)
        self.nav = self._get_value("nav_value", float)
        self.pe_ratio = self._get_value("pe_ratio_value", float)
        self.yield_value = round(float(self._get_value("yield_value", str).replace('%', '')) / 100, 4) if self._get_value("yield_value", str) else None
        self.ytd_daily_total_return = round(float(self._get_value("ytd_daily_total_return", str).replace('%', '')) / 100, 4) if self._get_value("ytd_daily_total_return", str) else None
        self.beta_5_year_monthly = self._get_value("beta_5_year_monthly", float)
        self.net_expense_ratio = round(float(self._get_value("net_expense_ratio", str).replace('%', '')) / 100, 4) if self._get_value("net_expense_ratio", str) else None
        self.inception_date = self._get_value("inception_date", str)

    def _get_value(self, value_tag: str, return_type, from_tag: bool = False):
        value = self.data.get(value_tag)
        if value:
            if from_tag:
                clean_value = re.search('value="(.+?)"', str(value)).group(1)
            else:
                clean_value = str(value).split('<')[1].split('>')[-1].replace(',', '')

            return return_type(clean_value) if clean_value != "N/A" else None

        else:
            return None

    def dict(self):
        payload = {}
        for key, value in self.__dict__.items():
            if key != "data":
                payload[key] = value
        return payload


def make_request(symbol: str) -> BeautifulSoup:
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0'}
    r = requests.get(url=f"https://uk.finance.yahoo.com/quote/{symbol}?p={symbol}", headers=headers)
    html = BeautifulSoup(r.text, features='html.parser')
    return html


def get_text_from_html(html: BeautifulSoup, div_name: str, attrs: dict):
    value = html.find(div_name, attrs=attrs)
    return value


def get_data_block(html: BeautifulSoup):
    data = {
        "price": get_text_from_html(html=html, div_name="fin-streamer", attrs={"data-test": "qsp-price", "data-field": "regularMarketPrice"}),
        "change": get_text_from_html(html=html, div_name="fin-streamer", attrs={"data-test": "qsp-price-change"}),
        "change_percent": get_text_from_html(html=html, div_name="fin-streamer", attrs={"data-field": "regularMarketChangePercent"}),
        "previous_close": get_text_from_html(html=html, div_name="td", attrs={"data-test": "PREV_CLOSE-value"}),
        "open_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "OPEN-value"}),
        "bid_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "BID-value"}),
        "ask_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "ASK-value"}),
        "days_range_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "DAYS_RANGE-value"}),
        "year_week_range_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "FIFTY_TWO_WK_RANGE-value"}),
        "volume_value": get_text_from_html(html=html, div_name="fin-streamer", attrs={"data-field": "regularMarketVolume"}),
        "avg_3_month_volume": get_text_from_html(html=html, div_name="td", attrs={"data-test": "AVERAGE_VOLUME_3MONTH-value"}),
        "net_assets_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "NET_ASSETS-value"}),
        "nav_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "NAV-value"}),
        "pe_ratio_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "PE_RATIO-value"}),
        "yield_value": get_text_from_html(html=html, div_name="td", attrs={"data-test": "TD_YIELD-value"}),
        "ytd_daily_total_return": get_text_from_html(html=html, div_name="td", attrs={"data-test": "YTD_DTR-value"}),
        "beta_5_year_monthly": get_text_from_html(html=html, div_name="td", attrs={"data-test": "BETA_5Y-value"}),
        "net_expense_ratio": get_text_from_html(html=html, div_name="td", attrs={"data-test": "EXPENSE_RATIO-value"}),
        "inception_date": get_text_from_html(html=html, div_name="td", attrs={"data-test": "FUND_INCEPTION_DATE-value"})
    }
    return data


def write_to_s3(symbol: str, payload: dict, bucket_name: str, dry_run: bool = False):
    if dry_run is False:
        client = boto3.client('s3')
        year = datetime.date.today().year
        month = datetime.date.today().month
        day = datetime.date.today().strftime("%Y-%m-%d")

        s3_key = f"{symbol}/hourly/{year}/{month}/{day}.json"

        # Get the file if exists else create it.
        try:
            obj = client.get_object(Bucket=bucket_name, Key=s3_key)
            upload_data = json.loads(obj['Body'].read())
        except:
            upload_data = []

        upload_data.append(payload)
        client.put_object(Body=json.dumps(upload_data), Bucket=bucket_name, Key=s3_key)
    else:
        print('Dry Run enabled. No file written to S3')


def lambda_handler(event, context):

    ticker = event.get('ticker')
    dry_run = bool(event.get('dry_run'))
    bucket_name = event.get('bucket_name')

    if ticker == "VUSA":
        marker = "VUSA.L"
    else:
        marker = ticker

    text = make_request(marker)
    raw_data = get_data_block(text)
    clean_data = VUSA(raw_data)
    write_to_s3(symbol=ticker, bucket_name=bucket_name, payload=clean_data.dict(), dry_run=dry_run)
    return clean_data.__dict__


if __name__ == '__main__':
    from pprint import pprint
    result = lambda_handler(
        event={
            "ticker": "VUSA",
            "dry_run": "true",
            "bucket_name": "dev-stock-tracker-raw"
        },
        context=None
    )
    pprint(result)
