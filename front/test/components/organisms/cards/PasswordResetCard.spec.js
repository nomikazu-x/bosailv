import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import PasswordResetForm from '~/components/organisms/form/PasswordResetForm.vue'
import Component from '~/components/organisms/cards/PasswordResetCard.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('PasswordResetCard.vue', () => {
  let axiosPostMock, toastedErrorMock, toastedInfoMock, routerPushMock

  beforeEach(() => {
    axiosPostMock = null
    toastedErrorMock = jest.fn()
    toastedInfoMock = jest.fn()
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
        PasswordResetForm: true
      },
      mocks: {
        $config: {
          apiBaseURL: 'https://example.com',
          passwordNewUrl: '/api/v1/auth/password.json',
          frontBaseURL: 'https://front.example.com',
          passwordRedirectUrl: '/password/reset/confirm'
        },
        $axios: {
          post: axiosPostMock
        },
        $auth: {
          loggedIn
        },
        $route: {
          path: '/settings/reset',
          query: { ...query }
        },
        $toasted: {
          error: toastedErrorMock,
          info: toastedInfoMock
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
    expect(wrapper.findComponent(PasswordResetForm).exists()).toBe(true)
    expect(wrapper.findComponent(PasswordResetForm).vm.$props.processing).toBe(false)
  }
  const commonToastedTest = (alert, notice) => {
    expect(toastedErrorMock).toBeCalledTimes(alert !== null ? 1 : 0)
    if (alert !== null) {
      expect(toastedErrorMock).toBeCalledWith(alert)
    }
    expect(toastedInfoMock).toBeCalledTimes(notice !== null ? 1 : 0)
    if (notice !== null) {
      expect(toastedInfoMock).toBeCalledWith(notice)
    }
  }
  const commonRedirectTest = (url) => {
    expect(routerPushMock).toBeCalledTimes(1)
    expect(routerPushMock).toBeCalledWith(url)
  }
  const commonApiCalledTest = (values) => {
    expect(axiosPostMock).toBeCalledTimes(1)
    expect(axiosPostMock).toBeCalledWith('https://example.com/api/v1/auth/password.json', {
      email: values.email,
      redirect_url: 'https://front.example.com/password/reset/confirm'
    })
  }

  describe('パスワード再設定API', () => {
    const data = Object.freeze({ alert: 'alertメッセージ', notice: 'noticeメッセージ' })
    const values = Object.freeze({ email: 'user1@example.com' })

    it('[成功]ログインページにリダイレクトされる', async () => {
      axiosPostMock = jest.fn(() => Promise.resolve({ data }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetForm).vm.$emit('password-new', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonRedirectTest({ path: '/signin', query: { alert: data.alert, notice: data.notice } })
    })

    it('[入力エラー]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.reject({ response: { status: 422, data: Object.assign({ errors: { email: ['errorメッセージ'] } }, data) } }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetForm).vm.$emit('password-new', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonMessageTest(wrapper, data.alert, data.notice)
    })

    it('[連携エラー]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.reject({ response: { status: 422, data: Object.assign({ errors: null }, data) } }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetForm).vm.$emit('password-new', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonMessageTest(wrapper, data.alert, data.notice)
    })

    it('[接続エラー]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.reject({ response: null }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetForm).vm.$emit('password-new', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonToastedTest(locales.network.failure, null)
    })

    it('[レスポンスエラー]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.reject({ response: { status: 500 } }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetForm).vm.$emit('password-new', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonToastedTest(locales.network.error, null)
    })

    it('[データなし]エラーメッセージが表示される', async () => {
      axiosPostMock = jest.fn(() => Promise.resolve({ data: null }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(PasswordResetForm).vm.$emit('password-new', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonToastedTest(locales.system.error, null)
    })
  })
})
