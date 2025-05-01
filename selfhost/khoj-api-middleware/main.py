from flask import Flask, request, Response
import requests
import os
from flask_httpauth import HTTPTokenAuth

app = Flask(__name__)
auth = HTTPTokenAuth(scheme="Bearer")

KHOJ_SERVICE_URL = os.environ.get("KHOJ_SERVICE_URL")
KHOJ_API_TOKEN = os.environ.get("KHOJ_API_TOKEN")

if None in [KHOJ_SERVICE_URL, KHOJ_API_TOKEN]:
    raise EnvironmentError('Required environment variables not set')


@auth.verify_token
def verify_token(token):
    return token == KHOJ_API_TOKEN


@app.route('/<path:path>', methods=['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'])
@auth.login_required
def proxy(path):
    # Forward request to actual backend
    resp = requests.request(
        method=request.method,
        url=f"{KHOJ_SERVICE_URL}/{path}",
        headers={key: value for key, value in request.headers.items() if key.lower() != 'host'},
        data=request.get_data(),
        cookies=request.cookies,
        allow_redirects=False)

    excluded_headers = ['content-encoding', 'content-length', 'transfer-encoding', 'connection']
    headers = [(name, value) for name, value in resp.raw.headers.items()
              if name.lower() not in excluded_headers]

    response = Response(resp.content, resp.status_code, headers)
    return response


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)