"use client"

import { useState, useEffect } from "react"
import type { AxiosResponse } from "axios"

export function useApi<T>(apiCall: () => Promise<AxiosResponse<T>>, dependencies: any[] = []) {
  const [data, setData] = useState<T | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true)
        setError(null)
        const response = await apiCall()
        setData(response.data)
      } catch (err: any) {
        setError(err.response?.data?.error || err.message || "Error desconocido")
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, dependencies)

  const refetch = async () => {
    try {
      setLoading(true)
      setError(null)
      const response = await apiCall()
      setData(response.data)
    } catch (err: any) {
      setError(err.response?.data?.error || err.message || "Error desconocido")
    } finally {
      setLoading(false)
    }
  }

  return { data, loading, error, refetch }
}
