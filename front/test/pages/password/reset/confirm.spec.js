import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import OneColumnContainer from '~/components/molecules/containers/OneColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import PasswordResetConfirmCard from '~/components/organisms/cards/PasswordResetConfirmCard.vue'
import Page from '~/pages/password/reset/confirm.vue'

// import { Helper } from '~/test/helper.js'
// const helper = new Helper()

describe('confirm.vue', () => {
  let authSetUserMock, toastedErrorMock, toastedSuccessMock, routerPushMock

  beforeEach(() => {
    authSetUserMock = jest.fn()
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
        PasswordResetConfirmCard: true
      },
      mocks: {
        $auth: {
          loggedIn,
          setUser: authSetUserMock
        },
        $route: {
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
    expect(wrapper.findComponent(PasswordResetConfirmCard).exists()).toBe(true)
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
    const query = Object.freeze({ reset_password_token: 'token' })
    const wrapper = mountFunction(false, query)
    commonViewTest(wrapper, null, null)
  })
  it('[ログイン中]トップページにリダイレクトされる', () => {
    mountFunction(true)
    commonRedirectTest(null, locales.auth.already_authenticated, { path: '/home' })
  })

  describe('トークンエラー', () => {
    const query = Object.freeze({ reset_password: 'false', alert: 'alertメッセージ', notice: 'noticeメッセージ' })
    it('[未ログイン]パスワード再設定にリダイレクトされる', () => {
      mountFunction(false, query)
      commonRedirectTest(null, null, { path: '/password/reset', query: { alert: query.alert, notice: query.notice } })
    })
    it('[ログイン中]トップページにリダイレクトされる', () => {
      mountFunction(true, query)
      commonRedirectTest(null, locales.auth.already_authenticated, { path: '/home' })
    })
  })

  describe('トークンnull', () => {
    const query = Object.freeze({ reset_password_token: null })
    it('[未ログイン]パスワード再設定にリダイレクトされる', () => {
      mountFunction(false, query)
      commonRedirectTest(null, null, { path: '/password/reset', query: { alert: locales.auth.reset_password_token_blank } })
    })
    it('[ログイン中]トップページにリダイレクトされる', () => {
      mountFunction(true, query)
      commonRedirectTest(null, locales.auth.already_authenticated, { path: '/home' })
    })
  })

  describe('トークンなし', () => {
    const query = Object.freeze({ reset_password_token: '' })
    it('[未ログイン]パスワード再設定にリダイレクトされる', () => {
      mountFunction(false, query)
      commonRedirectTest(null, null, { path: '/password/reset', query: { alert: locales.auth.reset_password_token_blank } })
    })
    it('[ログイン中]トップページにリダイレクトされる', () => {
      mountFunction(true, query)
      commonRedirectTest(null, locales.auth.already_authenticated, { path: '/home' })
    })
  })
})
