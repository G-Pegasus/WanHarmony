import { ApiService } from '../api/ApiService'
import { DataX } from '../data/ArticlesTree'
import { BannerItem } from '../data/BannerItem'
import { log } from '../utils/LogUtils'
import { ArticleComponent } from './components/ArticleComponent'

let service: ApiService

PersistentStorage.persistProp<BannerItem[]>("bannerList", [])
PersistentStorage.persistProp<DataX[]>("homeTopList", [])
PersistentStorage.persistProp<DataX[]>("homeList", [])

@Component
export struct HomePage {
  pathStack: NavPathStack | null = null
  // 滚动控制，可使用 listScroller 实现代码滚动
  private scroller: Scroller = new Scroller();
  @StorageLink('bannerList') bannerList: BannerItem[] = []
  @StorageLink('homeTopList') homeTopList: DataX[] = []
  @StorageLink('homeList') homeList: DataX[] = []
  @State isRefreshing: boolean = false
  @State isLoadingMore: boolean = false
  @State currentPage: number = 0

  aboutToAppear(): void {
    service = ApiService.instance
    this.loadData()
  }

  @Builder
  stickyHead(text: string) {
    Stack() {
      Text(`${text}`)
        .align(Alignment.Center)
        .fontColor(Color.White)
    }
    .width("100%")
    .backgroundColor($r("app.color.color_fore"))
  }

  build() {
    RelativeContainer() {
      Image($r("app.media.icon_scroll_to_top"))
        .width(30)
        .height(30)
        .margin({ bottom: 50, right: 10 })
        .zIndex(1)
        .onClick(() => {
          this.scroller.scrollToIndex(0)
        })
        .alignRules({
          end: { anchor: '__container__', align: HorizontalAlign.End},
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom}
        })

      Refresh({ refreshing: this.isRefreshing}) {
        List({
          scroller: this.scroller
        }) {

          if (this.bannerList.length > 0) {
            ListItemGroup() {
              ListItem() {
                Swiper() {
                  ForEach(this.bannerList, (item: BannerItem) => {
                    Image(item.imagePath)
                      .width('100%')
                      .height('30%')
                      .onClick(() => {
                        this.pathStack?.pushPathByName("WebPage", item.url, (popInfo) => {
                          const result = popInfo.result as Record<string, string>
                          if (result) {
                            log(`<<<<<<${result}`)
                          }
                        })
                        log("跳转 WebPage")
                      })
                  })
                }
                .loop(true)
                .autoPlay(true)
                .interval(3000)
              }
              .width("100%")
              .align(Alignment.Center)
            }
            .width("100%")
          }

          if (this.homeTopList.length > 0) {
            ListItemGroup({ space: 10, header: this.stickyHead("推荐文章") }) {
              ForEach(this.homeList, (item: DataX, index: number) => {
                ArticleComponent(item, index, () => {
                  this.pathStack?.pushPathByName("WebPage", item.link, (popInfo) => {
                    const result = popInfo.result as Record<string, string>
                    if (result) {
                      log(`<<<<<<${result.result}`)
                    }
                  })
                  log("跳转 WebPage")
                })
              })
            }
            .width("100%")
          }

          if (this.homeList.length > 0) {
            ListItemGroup({ space: 10, header: this.stickyHead("推荐文章") }) {
              ForEach(this.homeList, (item: DataX, index: number) => {
                ArticleComponent(item, index + this.homeTopList.length, () => {
                  this.pathStack?.pushPathByName("WebPage", item.link, (popInfo) => {
                    const result = popInfo.result as Record<string, string>
                    if (result) {
                      log(`<<<<<<${result.result}`)
                    }
                  })
                  log("跳转 WebPage")
                })
              })
            }
            .width("100%")
          }
        }
        .width("100%")
        .height("100%")
        .backgroundColor(0xE5E5E5)
        .listDirection(Axis.Vertical)
        .sticky(StickyStyle.Header) // ListItemGroup 的 header + List 的 sticky 实现粘性头
        .onReachEnd(() => {
          console.log("onReachEnd")
          if (!this.isLoadingMore) {
            this.isLoadingMore = true
            this.currentPage++
            this.loadList()
            console.log(`loadMore: this.currentPage = ${this.currentPage}`)
          }
        })
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        log('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onOffsetChange((value: number) => {
        log('Refresh onOffsetChange offset:' + value)
      })
      .onRefreshing(() => {
        setTimeout(() => { // 延迟后 恢复可刷新状态
          this.isRefreshing = false
        }, 2000)
        this.currentPage = 0
        this.loadData()
      })
      .backgroundColor(0xE5E5E5)
      .refreshOffset(64)
      .pullToRefresh(true)
    }
  }

  // 加载数据
  loadData() {
    service.getBanner().then(result => {
      this.bannerList = result
    })
    log(`"长度" + ${this.bannerList.length}`, "bannerlength")
    service.getHomeTopList().then(result => {
      this.homeTopList = result
    })
    this.loadList()
    log(`"长度" + ${this.homeList.length}`, "homelength")
  }

  loadList() {
    service.getHomeList(this.currentPage).then(result => {
      if (this.currentPage == 0) {
        // 加载首页
        this.homeList = result.datas // 不要清空数组再 concat，否则页面会有一瞬间变空
      } else {
        // 加载更多
        this.homeList = this.homeList.concat(result.datas)
        setTimeout(() => { // 延迟后 恢复可加载更多状态
          this.isLoadingMore = false
        }, 1500)
      }
    })
  }
}