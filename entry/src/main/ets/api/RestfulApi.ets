import axios, { type AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig, AxiosError } from '@ohos/axios'
import { ApiPath } from './ApiPath'
import { buffer, JSON } from '@kit.ArkTS'
import { log } from '../utils/LogUtils'

const TAG = '[RestfulAPI]'
const instance = axios.create({timeout: 10000})

function getDataBuffer(config: AxiosRequestConfig) {
  let str = ' '
  try {
    if (config.data) {
      str = JSON.stringify(config.data)
    }
  } catch {}

  return buffer.from(str)
}

export interface ErrorResponse {
  errorCode?: number,
  errorMsg?: string
}

instance.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  if (config.url) {
    config.url = encodeURI(config.url)
  }

  return config
}, (error: AxiosError) => {
  log(error.message, TAG)
  return Promise.reject(error)
})

instance.interceptors.response.use(
  (response: AxiosResponse) => {
    return response.data
  },

  (error: AxiosError) => {
    log(error.message, TAG)
    return Promise.reject(error)
  }
)

export class RestfulApi {
  public static async getResponse<T = undefined>(req: AxiosRequestConfig) {
    req.baseURL = ApiPath.BASE_URL;
    return await instance.request<null, T, null>(req)
  }
}