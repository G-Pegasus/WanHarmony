import axios, { type AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig, AxiosError } from '@ohos/axios'
import { ApiPath } from './ApiPath'
import { log } from '../utils/LogUtils'

const TAG = '[RestfulAPI]'
const instance = axios.create({timeout: 10000})

instance.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  if (config.url) {
    config.url = encodeURI(config.url)
  }

  config.headers['Content-Type'] = 'application/x-www-form-urlencoded'

  return config
}, (error: AxiosError) => {
  log(error.message, TAG)
  return Promise.reject(error)
})

instance.interceptors.response.use(
  (response: AxiosResponse) => {
    if (response.status === 200) {
      log(response.status.toString(), TAG)
      response.data = JSON.parse(response.data.toString())
      return Promise.resolve(response.data)
    }
    return Promise.reject(response)
  },

  (error: AxiosError) => {
    log(error.message, TAG)
    return Promise.reject(error)
  }
)

export class RestfulApi {
  public static async getResponse<T = undefined>(req: AxiosRequestConfig) {
    req.baseURL = ApiPath.BASE_URL;
    return await instance.request<null, T>(req)
  }
}