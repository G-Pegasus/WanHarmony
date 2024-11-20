import { SuperUserInfo, UserInfo } from "../data/UserInfo"
import { ApiPath } from "./ApiPath"
import { RestfulApi } from "./RestfulApi"
import { BannerItem } from "../data/BannerItem"
import { Articles, DataX } from "../data/ArticlesTree"
import Service from "./Service"

export class ApiService extends Service {
  private static _instance: ApiService
  private constructor() {
    super()
  }

  static get instance() {
    if (!ApiService._instance) {
      ApiService._instance = new ApiService()
    }
    return ApiService._instance
  }

  // 注册
  async register(username: string, password: string, repassword: string): Promise<UserInfo> {
    return RestfulApi.getResponse<UserInfo>({
      url: ApiPath.USER_REGISTER,
      method: 'POST',
      data: {
        username: username,
        password: password,
        repassword: repassword
      }
    })
  }

  // 登录
  async login(username: string, password: string): Promise<UserInfo> {
    return RestfulApi.getResponse<UserInfo>({
      url: ApiPath.USER_LOGIN,
      method: 'POST',
      data: {
        username: username,
        password: password
      }
    })
  }

  // 登出
  async logout(): Promise<null> {
    return RestfulApi.getResponse<null>({
      url: ApiPath.USER_LOGOUT,
      method: 'GET'
    })
  }

  // 个人信息
  async getUserInfo(): Promise<SuperUserInfo> {
    let user = await RestfulApi.getResponse<SuperUserInfo>({
      url: ApiPath.USER_INFO,
      method: 'GET'
    })
    AppStorage.setOrCreate("SuperUserInfo", JSON.stringify(user))
    return user
  }

  // 未读消息数量
  async getUnreadMessage(): Promise<string> {
    return await RestfulApi.getResponse<string>({
      url: ApiPath.UNREAD_MESSAGE_COUNT,
      method: 'GET'
    })
  }

  // 已读消息列表
  async getReadMessageList(page: number = 1): Promise<string> {
    return await RestfulApi.getResponse<string>({
      url: ApiPath.READ_MESSAGE_LIST(page),
      method: 'GET'
    })
  }

  // 未读消息列表
  async getUnReadMessageList(page: number = 1): Promise<string> {
    return await RestfulApi.getResponse<string>({
      url: ApiPath.UNREAD_MESSAGE_LIST(page),
      method: 'GET'
    })
  }

  // 获取轮播图
  async getBanner(): Promise<BannerItem[]> {
    return RestfulApi.getResponse<BannerItem[]>({
      url: ApiPath.BANNER,
      method: 'GET'
    })
  }

  // 置顶文章
  async getHomeTopList(): Promise<DataX[]> {
    return RestfulApi.getResponse<DataX[]>({
      url: ApiPath.HOME_TOP_LIST,
      method: 'GET'
    })
  }

  // 首页文章列表
  async getHomeList(page: number = 0, pageSize: number = 10): Promise<Articles> {
    return RestfulApi.getResponse<Articles>({
      url: ApiPath.HOME_LIST(page),
      method: 'GET',
      data: {
        page: page,
        page_size: pageSize
      }
    })
  }

  // banner
  // async getBanner(): Promise<BannerItem[]> {
  //   return this.request<BannerItem[]>('get', ApiPath.BANNER);
  // }

  // // 置顶文章
  // async getHomeTopList(): Promise<DataX[]> {
  //   return this.request<DataX[]>('get', ApiPath.HOME_TOP_LIST);
  // }
  //
  // // 首页文章列表
  // async getHomeList(page: number = 0, pageSize: number = 10): Promise<Articles> {
  //   const map = new Map<string, string>();
  //   map.set("page", String(page));
  //   map.set("page_size", String(pageSize));
  //   return this.request<Articles>('get', ApiPath.HOME_LIST(page), map);
  // }
}