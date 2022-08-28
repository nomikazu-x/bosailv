import Vuetify from 'vuetify'
import Vuex from 'vuex'
import { createLocalVue, mount } from '@vue/test-utils'
import Component from '~/components/organisms/sidebar/TheSidebar.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('default.vue', () => {
  let storeGettersMock

  beforeEach(() => {
    storeGettersMock = jest.fn()
  })

  const mountFunction = (loggedIn) => {
    const localVue = createLocalVue()
    localVue.use(Vuex)
    const vuetify = new Vuetify()
    const wrapper = mount(Component, {
      localVue,
      vuetify,
      mocks: {
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
          getters: storeGettersMock
        }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  const commonViewTest = (wrapper, loggedIn) => {
    // console.log(wrapper.html())

    const links = helper.getLinks(wrapper)

    // console.log(links)
    expect(links.includes('/signin')).toBe(!loggedIn) // [未ログイン]ログイン
    expect(links.includes('/signup')).toBe(!loggedIn) // [未ログイン]アカウント登録
    expect(links.includes('/shelters')).toBe(true) // 避難所検索
    expect(links.includes('/hazard_maps')).toBe(true) // ハザードマップ検索
    expect(links.includes('/sns_tasks')).toBe(true) // 防災SNS
    expect(links.includes('/house_tasks')).toBe(true) // おうちタスク
    expect(links.includes('/emergency_contacts')).toBe(true) // 緊急時連絡先一覧
    expect(links.includes('/stocks')).toBe(true) // 備蓄品
    expect(links.includes('/family_rule')).toBe(true) // 家族会議
    expect(links.includes('/infomations')).toBe(true) // お知らせ一覧
    expect(links.includes('/articles')).toBe(true) // 記事一覧
    expect(links.includes('/genres')).toBe(true) // ジャンル一覧
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
