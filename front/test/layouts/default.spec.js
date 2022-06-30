import Vuetify from 'vuetify'
import Vuex from 'vuex'
import { createLocalVue, mount } from '@vue/test-utils'
import GoTop from '@inotom/vue-go-top'
import Layout from '~/layouts/default.vue'
import TheHeader from '~/components/organisms/header/TheHeader.vue'
import TheSidebar from '~/components/organisms/sidebar/TheSidebar.vue'
import LevelUpModal from '~/components/organisms/modals/LevelUpModal.vue'
import TheFooter from '~/components/organisms/footer/TheFooter.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('default.vue', () => {
  let storeGettersMock, storeSubcribeMock

  beforeEach(() => {
    storeGettersMock = jest.fn()
    storeSubcribeMock = jest.fn()
  })

  const mountFunction = (loggedIn) => {
    const localVue = createLocalVue()
    localVue.use(Vuex)
    const vuetify = new Vuetify()
    const wrapper = mount(Layout, {
      localVue,
      vuetify,
      stubs: {
        GoTop: true,
        TheHeader,
        TheSidebar,
        LevelUpModal,
        TheFooter,
        Nuxt: true
      },
      mocks: {
        $config: {
          envName: ''
        },
        $auth: {
          loggedIn,
          user: {
            name: 'user1の氏名',
            image_url: {
              small: 'https://example.com/images/user/small_noimage.jpg'
            },
            infomation_unread_count: 12345
          }
        },
        $store: {
          getters: storeGettersMock,
          subscribe: storeSubcribeMock
        }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  const commonViewTest = (wrapper, loggedIn) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(GoTop).exists()).toBe(true) // 上に戻る
    expect(wrapper.findComponent(TheHeader).exists()).toBe(true) // ヘッダー
    expect(wrapper.findComponent(TheSidebar).exists()).toBe(true) // サイドバー
    expect(wrapper.findComponent(LevelUpModal).exists()).toBe(true) // レベルアップモーダル
    expect(wrapper.findComponent(TheFooter).exists()).toBe(true) // フッター
    expect(wrapper.html()).toMatch('<nuxt-stub></nuxt-stub>')

    const links = helper.getLinks(wrapper)

    // console.log(links)
    expect(links.includes('/')).toBe(true) // トップページ
    expect(links.includes('/signin')).toBe(!loggedIn) // [未ログイン]ログイン
    expect(links.includes('/signup')).toBe(!loggedIn) // [未ログイン]アカウント登録
    expect(links.includes('/infomations')).toBe(true) // お知らせ一覧
    expect(links.includes('/articles')).toBe(true) // 記事一覧
    expect(links.includes('/articles/search')).toBe(true) // 記事検索
    expect(links.includes('/articles/new')).toBe(loggedIn) // [ログイン中]記事作成
    expect(links.includes('/settings/profile')).toBe(loggedIn) // [ログイン中]設定
  }

  it('[未ログイン]表示される', () => {
    const wrapper = mountFunction(false)
    commonViewTest(wrapper, false)
  })
  it('[ログイン中]表示される', () => {
    const wrapper = mountFunction(true)
    commonViewTest(wrapper, true)
  })
})
