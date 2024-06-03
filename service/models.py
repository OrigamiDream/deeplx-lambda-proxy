from enum import Enum
from typing import List, Any, Dict, Union

from pydantic import BaseModel


class HttpMethod(Enum):
    GET = 'GET'
    POST = 'POST'
    PATCH = 'PATCH'
    DELETE = 'DELETE'
    PUT = 'PUT'


class Commitment(BaseModel):
    unique_id: str
    headers: Dict[str, Any]
    body: Dict[str, Any]


class CommitmentResult(BaseModel):
    unique_id: str
    status_code: int
    response: Union[Dict[str, Any], List[Any], str]


class CommitRequest(BaseModel):
    url: str
    http_method: HttpMethod
    commitments: List[Commitment]
    timeout_secs: float = 30


class CommitResponse(BaseModel):
    responses: List[CommitmentResult]
