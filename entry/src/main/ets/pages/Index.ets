import { log } from '../utils/LogUtils'
import { HomePage } from './HomePage'

@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack()
  @State currentIndex: number = 0

  build() {
    Navigation(this.pathStack) {
      Tabs() {
        TabContent() {
          HomePage({ pathStack: this.pathStack})
        }.tabBar(this.tabBuilder("首页", 0, $r("app.media.icon_home_selected"), $r("app.media.icon_home")))

        TabContent() {
          HomePage({ pathStack: this.pathStack})
        }.tabBar(this.tabBuilder("首页", 0, $r("app.media.icon_home_selected"), $r("app.media.icon_home")))
      }
      .barPosition(BarPosition.End)
      .scrollable(false)
      .onChange((index) => {
        this.currentIndex = index
        log(`tab index = ${index}`)
      })
    }
    .title("Index")
    .hideTitleBar(true)
    .hideNavBar(false)
    .mode(NavigationMode.Auto)
  }

  @Builder
  tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 20, height: 20 })
      Blank().height(5)

      Text(title)
        .fontSize(14)
        .fontColor(this.currentIndex === targetIndex ? $r("app.color.color_fore") : $r("app.color.color_back"))
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }
}