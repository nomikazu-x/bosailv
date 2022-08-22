import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import ArticleNewCard from '~/components/organisms/cards/article/ArticleNewCard.vue'
import Page from '~/pages/articles/new.vue'

// import { Helper } from '~/test/helper.js'
// const helper = new Helper()

describe('new.vue', () => {
  let authRedirectMock, toastedErrorMock, toastedSuccessMock, routerPushMock

  beforeEach(() => {
    authRedirectMock = jest.fn()
    toastedErrorMock = jest.fn()
    toastedSuccessMock = jest.fn()
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
        ArticleNewCard: true
      },
      mocks: {
        $auth: {
          loggedIn,
          redirect: authRedirectMock
        },
        $toasted: {
          error: toastedErrorMock,
          success: toastedSuccessMock
        },
        $router: {
          push: routerPushMock
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
    expect(wrapper.findComponent(ArticleNewCard).exists()).toBe(true)
  }
  const commonRedirectTest = (alert, notice, url, mock = routerPushMock) => {
    expect(toastedErrorMock).toBeCalledTimes(alert !== null ? 1 : 0)
    if (alert !== null) {
      expect(toastedErrorMock).toBeCalledWith(alert)
    }
    expect(toastedSuccessMock).toBeCalledTimes(notice !== null ? 1 : 0)
    if (notice !== null) {
      expect(toastedSuccessMock).toBeCalledWith(notice)
    }
    expect(mock).toBeCalledTimes(1)
    expect(mock).toBeCalledWith(url)
  }

  it('[未ログイン]ログインにリダイレクトされる', () => {
    mountFunction(false)
    commonRedirectTest(null, locales.auth.unauthenticated, 'login', authRedirectMock)
  })
  it('[ログイン中]表示される', () => {
    const wrapper = mountFunction(true)
    commonViewTest(wrapper)
  })
})
