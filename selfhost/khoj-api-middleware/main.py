from fastapi import FastAPI, Request, Response, HTTPException
from fastapi.responses import JSONResponse, StreamingResponse
import httpx
import os

app = FastAPI()

KHOJ_SERVICE_URL = os.environ.get("KHOJ_SERVICE_URL")
KHOJ_API_TOKEN = os.environ.get("KHOJ_API_TOKEN")

if None in [KHOJ_SERVICE_URL, KHOJ_API_TOKEN]:
    raise EnvironmentError(f'Environment not set: KHOJ_SERVICE_URL={KHOJ_SERVICE_URL}, KHOJ_API_TOKEN={KHOJ_API_TOKEN}')

@app.api_route("/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"])
async def proxy_api(request: Request, path: str):
    # Check for Bearer token
    auth = request.headers.get("authorization")
    expected_bearer = f"Bearer {KHOJ_API_TOKEN}"

    if not (auth and auth.startswith("Bearer ") and auth == expected_bearer):
        raise HTTPException(status_code=401, detail="Unauthorized")

    # Forward request to actual backend
    async with httpx.AsyncClient() as client:
        backend_url = f"{KHOJ_SERVICE_URL}/{path}"
        method = request.method
        headers = dict(request.headers)
        body = await request.body()
        resp = await client.request(method, backend_url, headers=headers, content=body)
        return StreamingResponse(resp.aiter_raw(), status_code=resp.status_code, headers=resp.headers)
