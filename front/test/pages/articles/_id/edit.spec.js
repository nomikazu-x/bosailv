import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import ArticleEditCard from '~/components/organisms/cards/article/ArticleEditCard.vue'
import Page from '~/pages/articles/_id/edit.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('edit.vue', () => {
  let axiosGetMock, authRedirectMock, toastedErrorMock, toastedInfoMock, routerPushMock

  beforeEach(() => {
    axiosGetMock = jest.fn()
    authRedirectMock = jest.fn()
    toastedErrorMock = jest.fn()
    toastedInfoMock = jest.fn()
    routerPushMock = jest.fn()
  })

  const mountFunction = (loggedIn) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Page, {
      localVue,
      vuetify,
      stubs: {
        OneColumnContainer: true,
        TheLoading: true,
        TheMessage: true,
        ArticleEditCard: true
      },
      mocks: {
        $config: {
          apiBaseURL: 'https://example.com',
          articleDetailUrl: '/api/v1/articles/_id.json'
        },
        $axios: {
          get: axiosGetMock
        },
        $auth: {
          loggedIn,
          user: {
            id: 1,
            name: 'user1の氏名',
            email: 'user1@example.com',
            admin: true
          },
          redirect: authRedirectMock
        },
        $toasted: {
          error: toastedErrorMock,
          info: toastedInfoMock
        },
        $router: {
          push: routerPushMock
        },
        $route: {
          params: {
            id: 1
          }
        }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  const commonViewTest = (wrapper) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(OneColumnContainer).exists()).toBe(true)
    expect(wrapper.findComponent(TheLoading).exists()).toBe(false)
    expect(wrapper.findComponent(TheMessage).exists()).toBe(true)
    expect(wrapper.findComponent(TheMessage).vm.$props.alert).toBe(null)
    expect(wrapper.findComponent(TheMessage).vm.$props.notice).toBe(null)
    expect(wrapper.findComponent(ArticleEditCard).exists()).toBe(true)
  }
  const commonGetApiCalledTest = () => {
    expect(axiosGetMock).toBeCalledTimes(1)
    expect(axiosGetMock).toBeCalledWith('https://example.com/api/v1/articles/1.json')
  }
  const commonRedirectTest = (alert, notice, url, mock = routerPushMock) => {
    expect(toastedErrorMock).toBeCalledTimes(alert !== null ? 1 : 0)
    if (alert !== null) {
      expect(toastedErrorMock).toBeCalledWith(alert)
    }
    expect(toastedInfoMock).toBeCalledTimes(notice !== null ? 1 : 0)
    if (notice !== null) {
      expect(toastedInfoMock).toBeCalledWith(notice)
    }
    expect(mock).toBeCalledTimes(1)
    expect(mock).toBeCalledWith(url)
  }

  describe('リダイレクトテスト', () => {
    const article = Object.freeze({ id: 1, user: { id: 1, name: 'user1の氏名', email: 'user1@example.com', admin: true } })

    it('[未ログイン]ログインにリダイレクトされる', async () => {
      axiosGetMock = jest.fn(() => Promise.resolve({ data: { article } }))
      mountFunction(false)

      await helper.sleep(1)
      commonGetApiCalledTest(0)
      commonRedirectTest(null, locales.auth.unauthenticated, 'login', authRedirectMock)
    })
    it('[ログイン中]表示される', async () => {
      axiosGetMock = jest.fn(() => Promise.resolve({ data: { article } }))
      const wrapper = mountFunction(true)

      await helper.sleep(1)
      commonGetApiCalledTest(0)
      commonViewTest(wrapper)
    })
  })
})
