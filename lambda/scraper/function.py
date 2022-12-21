import os
import requests


def lambda_handler(event, context):
    return f"{os.environ['env']} from Lambda"