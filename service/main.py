import mangum
import uvicorn
from fastapi import FastAPI

from service import routers
from service.config import Settings

settings = Settings()
app = FastAPI()
app.include_router(routers.router, prefix="/v{}".format(settings.function_index))

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=1188)

handler = mangum.Mangum(app)
