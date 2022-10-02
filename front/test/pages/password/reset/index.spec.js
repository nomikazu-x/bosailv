import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import PasswordResetCard from '~/components/organisms/cards/PasswordResetCard.vue'
import Page from '~/pages/password/reset/index.vue'

// import { Helper } from '~/test/helper.js'
// const helper = new Helper()

describe('index.vue', () => {
  let toastedErrorMock, toastedSuccessMock, routerPushMock

  beforeEach(() => {
    toastedErrorMock = jest.fn()
    toastedSuccessMock = jest.fn()
    routerPushMock = jest.fn()
  })

  const mountFunction = (loggedIn, query) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Page, {
      localVue,
      vuetify,
      stubs: {
        OneColumnContainer: true,
        TheLoading: true,
        TheMessage: true,
        PasswordResetCard: true
      },
      mocks: {
        $auth: {
          loggedIn
        },
        $route: {
          path: '/password/reset/index',
          query: { ...query }
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

  const commonViewTest = (wrapper, alert, notice) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(OneColumnContainer).exists()).toBe(true)
    expect(wrapper.findComponent(TheLoading).exists()).toBe(false)
    expect(wrapper.findComponent(TheMessage).exists()).toBe(true)
    expect(wrapper.findComponent(TheMessage).vm.$props.alert).toBe(alert)
    expect(wrapper.findComponent(TheMessage).vm.$props.notice).toBe(notice)
    expect(wrapper.findComponent(PasswordResetCard).exists()).toBe(true)
  }
  const commonRedirectTest = (alert, notice, url, count = 1) => {
    expect(toastedErrorMock).toBeCalledTimes(alert !== null ? 1 : 0)
    if (alert !== null) {
      expect(toastedErrorMock).toBeCalledWith(alert)
    }
    expect(toastedSuccessMock).toBeCalledTimes(notice !== null ? 1 : 0)
    if (notice !== null) {
      expect(toastedSuccessMock).toBeCalledWith(notice)
    }
    expect(routerPushMock).toBeCalledTimes(count)
    expect(routerPushMock).toBeCalledWith(url)
  }

  it('[未ログイン]表示される', () => {
    const query = Object.freeze({ alert: 'alertメッセージ', notice: 'noticeメッセージ' })
    const wrapper = mountFunction(false, query)
    commonViewTest(wrapper, query.alert, query.notice)
  })
  it('[ログイン中]トップページにリダイレクトされる', () => {
    mountFunction(true)
    commonRedirectTest(null, locales.auth.already_authenticated, { path: '/home' })
  })
})
