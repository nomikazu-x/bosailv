import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import PasswordResetConfirmForm from '~/components/organisms/form/PasswordResetConfirmForm.vue'
import Component from '~/components/organisms/cards/PasswordResetConfirmCard.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('PasswordResetConfirmCard.vue', () => {
  let axiosPostMock, authSetUserMock, toastedErrorMock, toastedSuccessMock, routerPushMock

  beforeEach(() => {
    axiosPostMock = null
    authSetUserMock = jest.fn()
    toastedErrorMock = jest.fn()
    toastedSuccessMock = jest.fn()
    routerPushMock = jest.fn()
  })

  const mountFunction = (loggedIn, query, values = null) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Component, {
      localVue,
      vuetify,
      stubs: {
        BaseTitleCard: true,
        PasswordResetConfirmForm: true
      },
      mocks: {
        $config: {
          apiBaseURL: 'https://example.com',
          passwordUpdateUrl: '/api/v1/auth/password/update.json'
        },
        $axios: {
          post: axiosPostMock
        },
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
      },
      data () {
        return { ...values }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }
  const commonMessageTest = (wrapper, alert, notice) => {
    expect(wrapper.emitted().alert).toEqual([[alert]])
    expect(wrapper.emitted().notice).toEqual([[notice]])
  }
  const commonViewTest = (wrapper) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(BaseTitleCard).exists()).toBe(true)
    expect(wrapper.findComponent(PasswordResetConfirmForm).exists()).toBe(true)
    expect(wrapper.findComponent(PasswordResetConfirmForm).vm.$props.processing).toBe(false)
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
  const commonRedirectTest = (alert, notice, url) => {
    commonToastedTest(alert, notice)
    expect(routerPushMock).toBeCalledTimes(1)
    expect(routerPushMock).toBeCalledWith(url)
  }
  const commonApiCalledTest = (values, setUserCalled) => {
    expect(axiosPostMock).toBeCalledTimes(1)
    expect(axiosPostMock).toBeCalledWith('https://example.com/api/v1/auth/password/update.json', {
      reset_password_token: values.reset_password_token,
      password: values.password,
      password_confirmation: values.password_confirmation
    })
    expect(authSetUserMock).toBeCalledTimes(setUserCalled)
  }

  describe('パスワード再設定API', () => {
    const data = Object.freeze({ alert: 'alertメッセージ', notice: 'noticeメッセージ' })
    const query = Object.freeze({ reset_password_token: 'token' })
    const values = Object.freeze({ reset_password_token: 'token', password: 'abc12345', password_confirmation: 'abc12345' })

    it('[成功]ログイン状態になり、トップページにリダイレクトされる', async () => {
      axiosPostMock = jest.fn(() => Promise.resolve({ data }))
      const wrapper = mountFunction(false, query, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetConfirmForm).vm.$emit('password-update', values)
      wrapper.vm.$auth.loggedIn = true // Tips: 状態変更（Mockでは実行されない為）

      await helper.sleep(1)
      commonApiCalledTest(values, 1)
      commonRedirectTest(data.alert, data.notice, { path: '/home' })
    })

    it('[入力エラー]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.reject({ response: { status: 422, data: Object.assign({ errors: { email: ['errorメッセージ'] } }, data) } }))
      const wrapper = mountFunction(false, query, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetConfirmForm).vm.$emit('password-update', values)

      await helper.sleep(1)
      commonApiCalledTest(values, 0)
      commonMessageTest(wrapper, data.alert, data.notice)
    })

    it('[連携エラー]パスワード再設定（メールアドレス入力）にリダイレクトされる', async () => {
      axiosPostMock = jest.fn(() => Promise.reject({ response: { status: 422, data: Object.assign({ errors: null }, data) } }))
      const wrapper = mountFunction(false, query, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetConfirmForm).vm.$emit('password-update', values)

      await helper.sleep(1)
      commonApiCalledTest(values, 0)
      commonRedirectTest(null, null, { path: '/password/reset/confirm', query: { alert: data.alert, notice: data.notice } })
    })

    it('[接続エラー]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.reject({ response: null }))
      const wrapper = mountFunction(false, query, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetConfirmForm).vm.$emit('password-update', values)

      await helper.sleep(1)
      commonApiCalledTest(values, 0)
      commonToastedTest(locales.network.failure, null)
    })

    it('[レスポンスエラー]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.reject({ response: { status: 500 } }))
      const wrapper = mountFunction(false, query, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetConfirmForm).vm.$emit('password-update', values)

      await helper.sleep(1)
      commonApiCalledTest(values, 0)
      commonToastedTest(locales.network.error, null)
    })

    it('[データなし]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.resolve({ data: null }))
      const wrapper = mountFunction(false, query, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetConfirmForm).vm.$emit('password-update', values)

      await helper.sleep(1)
      commonApiCalledTest(values, 0)
      commonToastedTest(locales.system.error, null)
    })
  })
})
