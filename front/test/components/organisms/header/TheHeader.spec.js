import Vuetify from 'vuetify'
import Vuex from 'vuex'
import { createLocalVue, mount } from '@vue/test-utils'
import Component from '~/components/organisms/header/TheHeader.vue'

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
    expect(links.includes('/')).toBe(true) // トップページ
    expect(links.includes('/signin')).toBe(!loggedIn) // [未ログイン]ログイン
    expect(links.includes('/signup')).toBe(!loggedIn) // [未ログイン]アカウント登録
    expect(links.includes('/infomations')).toBe(loggedIn) // お知らせ一覧
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
