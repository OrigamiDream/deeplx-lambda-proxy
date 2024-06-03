import asyncio
from typing import Callable, Dict

from aiohttp import ClientTimeout, ClientSession
from fastapi import APIRouter, status

from service.models import CommitResponse, CommitRequest, Commitment, CommitmentResult, HttpMethod

router = APIRouter()


_HTTP_METHOD_MAPPINGS: Dict[HttpMethod, Callable[[ClientSession], Callable]] = {
    HttpMethod.GET: lambda x: x.get,
    HttpMethod.POST: lambda x: x.post,
    HttpMethod.DELETE: lambda x: x.delete,
    HttpMethod.PATCH: lambda x: x.patch,
    HttpMethod.PUT: lambda x: x.put,
}


def _get_method_func_by_http_method(http_method: HttpMethod, session: ClientSession):
    fn = _HTTP_METHOD_MAPPINGS.get(http_method, None)
    if not fn:
        raise ValueError('Insufficient HTTP method: {}'.format(http_method.value))
    return fn(session)


async def _commit_egress_reqs(
        base_url: str,
        http_method: HttpMethod,
        timeout_secs: float,
        commitment: Commitment) -> CommitmentResult:
    timeout = ClientTimeout(total=timeout_secs)
    async with ClientSession(timeout=timeout) as session:
        method = _get_method_func_by_http_method(http_method, session)
        async with method(base_url, headers=commitment.headers, json=commitment.body) as res:
            if res.status != status.HTTP_200_OK:
                return CommitmentResult(
                    unique_id=commitment.unique_id,
                    status_code=res.status,
                    response=await res.text(),
                )
            body = await res.json()
    return CommitmentResult(
        unique_id=commitment.unique_id,
        status_code=status.HTTP_200_OK,
        response=body,
    )


@router.get('/health')
async def health_check():
    return "200 OK"


@router.post('/commit', response_model=CommitResponse)
async def commit_req(request: CommitRequest):
    coroutines = []
    for commitment in request.commitments:
        coroutines.append(_commit_egress_reqs(request.url, request.http_method, request.timeout_secs, commitment))

    responses = await asyncio.gather(*coroutines)
    return CommitResponse(responses=responses)
