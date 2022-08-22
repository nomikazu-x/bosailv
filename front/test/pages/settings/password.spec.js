import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import TwoColumnContainer from '~/components/molecules/containers/TwoColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import SettingsMenusCard from '~/components/organisms/cards/settings/SettingsMenusCard.vue'
import SettingsPasswordCard from '~/components/organisms/cards/settings/SettingsPasswordCard.vue'
import Page from '~/pages/settings/password.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('password.vue', () => {
  let authFetchUserMock, authRedirectMock, authLogoutMock, toastedErrorMock, toastedSuccessMock, routerPushMock

  beforeEach(() => {
    authFetchUserMock = jest.fn()
    authRedirectMock = jest.fn()
    authLogoutMock = jest.fn()
    toastedErrorMock = jest.fn()
    toastedSuccessMock = jest.fn()
    routerPushMock = jest.fn()
  })

  const mountFunction = (loggedIn, user) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Page, {
      localVue,
      vuetify,
      stubs: {
        TwoColumnContainer: true,
        TheLoading: true,
        TheMessage: true,
        SettingsMenusCard: true,
        SettingsPasswordCard: true
      },
      mocks: {
        $auth: {
          loggedIn,
          user: { ...user },
          fetchUser: authFetchUserMock,
          redirect: authRedirectMock,
          logout: authLogoutMock
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

  const commonLoadingTest = (wrapper) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(TheLoading).exists()).toBe(true)
  }
  const commonFetchUserCalledTest = (logoutCalled) => {
    expect(authFetchUserMock).toBeCalledTimes(1)
    expect(authLogoutMock).toBeCalledTimes(logoutCalled)
  }
  const commonViewTest = (wrapper) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(TwoColumnContainer).exists()).toBe(true)
    expect(wrapper.findComponent(TheLoading).exists()).toBe(false)
    expect(wrapper.findComponent(TheMessage).exists()).toBe(true)
    expect(wrapper.findComponent(TheMessage).vm.$props.alert).toBe(null)
    expect(wrapper.findComponent(TheMessage).vm.$props.notice).toBe(null)
    expect(wrapper.findComponent(SettingsMenusCard).exists()).toBe(true)
    expect(wrapper.findComponent(SettingsPasswordCard).exists()).toBe(true)
  }
  const commonToastedTest = (alert, notice) => {
    expect(toastedErrorMock).toBeCalledTimes(alert !== null ? 1 : 0)
    if (alert !== null) {
      expect(toastedErrorMock).toBeCalledWith(alert)
    }
    expect(toastedSuccessMock).toBeCalledTimes(notice !== null ? 1 : 0)
    if (notice !== null) {
      expect(toastedSuccessMock).toBeCalledWith(notice)
    }
  }
  const commonRedirectTest = (alert, notice, url, mock = routerPushMock) => {
    commonToastedTest(alert, notice)
    expect(mock).toBeCalledTimes(1)
    expect(mock).toBeCalledWith(url)
  }

  it('[未ログイン]ログインにリダイレクトされる', async () => {
    const wrapper = mountFunction(false, {})
    commonLoadingTest(wrapper)

    await helper.sleep(1)
    commonFetchUserCalledTest(0)
    commonRedirectTest(null, locales.auth.unauthenticated, 'login', authRedirectMock)
  })
  it('[ログイン中]表示される', async () => {
    const wrapper = mountFunction(true, { destroy_schedule_at: null })
    commonLoadingTest(wrapper)

    await helper.sleep(1)
    commonFetchUserCalledTest(0)
    commonViewTest(wrapper)
  })
  it('[ログイン中(ゲストユーザー)]トップページにリダイレクトされる', async () => {
    const wrapper = mountFunction(true, { destroy_schedule_at: '2022-01-01T09:00:00+09:00' })
    commonLoadingTest(wrapper)

    await helper.sleep(1)
    commonFetchUserCalledTest(0)
    commonRedirectTest(locales.auth.destroy_reserved, null, { path: '/' })
  })

  describe('トークン検証API', () => {
    const user = Object.freeze()
    it('[接続エラー]トップページにリダイレクトされる', async () => {
      authFetchUserMock = jest.fn(() => Promise.reject({ response: null }))
      const wrapper = mountFunction(true, user)
      commonLoadingTest(wrapper)

      await helper.sleep(1)
      commonFetchUserCalledTest(0)
      commonRedirectTest(locales.network.failure, null, { path: '/' })
    })
    it('[認証エラー]未ログイン状態になり、ログインページにリダイレクトされる', async () => {
      authFetchUserMock = jest.fn(() => Promise.reject({ response: { status: 401 } }))
      const wrapper = mountFunction(true, user)
      commonLoadingTest(wrapper)

      await helper.sleep(1)
      commonFetchUserCalledTest(1)
      commonToastedTest(null, locales.auth.unauthenticated)
    })
    it('[レスポンスエラー]トップページにリダイレクトされる', async () => {
      authFetchUserMock = jest.fn(() => Promise.reject({ response: { status: 500 } }))
      const wrapper = mountFunction(true, user)
      commonLoadingTest(wrapper)

      await helper.sleep(1)
      commonFetchUserCalledTest(0)
      commonRedirectTest(locales.network.error, null, { path: '/' })
    })
  })
})
