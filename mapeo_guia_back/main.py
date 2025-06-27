from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import httpx
import os
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI()

# Middleware para permitir conexión desde React (localhost:3000)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# URL del servidor Python Flask (tu api.py)
PYTHON_SERVER_URL = "http://localhost:5000"

# Modelos Pydantic
class Registro(BaseModel):
    id: Optional[int] = None
    archivo: str
    ubicacion: str
    funcion: str
    descripcion: str
    orden: int
    nodo_id: str
    usuario: Optional[str] = "Anónimo"

class HistorialRegistro(BaseModel):
    registro_id: int
    fecha: str
    campo: str
    anterior: str
    nuevo: str
    usuario: str

# ➤ Rutas hacia servidor Flask 

@app.get("/api/nodos")
async def get_tree():
    async with httpx.AsyncClient() as client:
        res = await client.get(f"{PYTHON_SERVER_URL}/api/nodos")
        return res.json()

@app.post("/api/save-tree")
async def save_tree(data: dict):
    async with httpx.AsyncClient() as client:
        res = await client.post(f"{PYTHON_SERVER_URL}/api/save-tree", json=data)
        return res.json()

@app.get("/api/registros")
async def get_registros(nodo_id: str):
    async with httpx.AsyncClient() as client:
        res = await client.get(f"{PYTHON_SERVER_URL}/api/registros?nodo_id={nodo_id}")
        return res.json()

@app.post("/api/registro")
async def save_registro(registro: Registro):
    async with httpx.AsyncClient() as client:
        res = await client.post(f"{PYTHON_SERVER_URL}/api/registro", json=registro.model_dump())
        return res.json()

@app.delete("/api/delete-registro")
async def delete_registro(id: int):
    async with httpx.AsyncClient() as client:
        res = await client.delete(f"{PYTHON_SERVER_URL}/api/delete-registro?id={id}")
        return res.json()

@app.post("/api/reindex-orden")
async def reindex_orden(nodo_id: str):
    async with httpx.AsyncClient() as client:
        res = await client.post(f"{PYTHON_SERVER_URL}/api/reindex-orden", json={"nodo_id": nodo_id})
        return res.json()

@app.get("/api/historial_registro/{registro_id}")
async def get_historial_registro(registro_id: int):
    async with httpx.AsyncClient() as client:
        res = await client.get(f"{PYTHON_SERVER_URL}/api/historial_registro/{registro_id}")
        return res.json()

@app.post("/api/history")
async def add_history_entry(entry: HistorialRegistro):
    async with httpx.AsyncClient() as client:
        res = await client.post(f"{PYTHON_SERVER_URL}/api/historial_registro", json=entry.model_dump())
        return res.json()

@app.get("/api/read-sql")
async def read_sql_file(path: str):
    async with httpx.AsyncClient() as client:
        res = await client.get(f"{PYTHON_SERVER_URL}/api/read-sql?path={path}")
        return {"content": res.text}

@app.get("/api/open-sql")
async def open_sql_file(path: str):
    async with httpx.AsyncClient() as client:
        res = await client.get(f"{PYTHON_SERVER_URL}/api/open-sql?path={path}")
        return res.json()