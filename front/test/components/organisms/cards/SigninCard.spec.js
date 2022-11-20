import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import SigninForm from '~/components/organisms/form/SigninForm.vue'
import Component from '~/components/organisms/cards/SigninCard.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('SigninCard.vue', () => {
  let authLoginWithMock, toastedErrorMock, toastedSuccessMock, routerPushMock

  beforeEach(() => {
    authLoginWithMock = null
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
        SigninForm: true
      },
      mocks: {
        $config: {
          frontBaseURL: 'https://front.example.com',
          singUpSuccessUrl: '/signin',
          unlockRedirectUrl: '/signin'
        },
        $auth: {
          loggedIn,
          loginWith: authLoginWithMock
        },
        $route: {
          path: '/signin',
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
    expect(wrapper.findComponent(SigninForm).exists()).toBe(true)
    expect(wrapper.findComponent(SigninForm).vm.$props.processing).toBe(false)
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
  const commonApiCalledTest = (values) => {
    expect(authLoginWithMock).toBeCalledTimes(1)
    expect(authLoginWithMock).toBeCalledWith('local', {
      data: {
        email: values.email,
        password: values.password,
        unlock_redirect_url: 'https://front.example.com/signin'
      }
    })
  }

  describe('ログインAPI', () => {
    const data = Object.freeze({ alert: 'alertメッセージ', notice: 'noticeメッセージ' })
    const values = Object.freeze({ email: 'user1@example.com', password: 'abc12345' })

    it('[成功]ログイン状態になり、元のページにリダイレクトされる', async () => {
      authLoginWithMock = jest.fn(() => Promise.resolve({ data }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(SigninForm).vm.$emit('sign-in', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonToastedTest(data.alert, data.notice)
      // Tips: 状態変更・リダイレクトのテストは省略（Mockでは実行されない為）
    })

    it('[入力・連携エラー]エラーメッセージが表示される', async () => {
      authLoginWithMock = jest.fn(() => Promise.reject({ response: { status: 422, data } }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(SigninForm).vm.$emit('sign-in', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonMessageTest(wrapper, data.alert, data.notice)
    })

    it('[接続エラー]エラーメッセージが表示される', async () => {
      authLoginWithMock = jest.fn(() => Promise.reject({ response: null }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(SigninForm).vm.$emit('sign-in', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonToastedTest(locales.network.failure, null)
    })

    it('[レスポンスエラー]エラーメッセージが表示される', async () => {
      authLoginWithMock = jest.fn(() => Promise.reject({ response: { status: 500 } }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(SigninForm).vm.$emit('sign-in', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonToastedTest(locales.network.error, null)
    })

    it('[データなし]エラーメッセージが表示される', async () => {
      authLoginWithMock = jest.fn(() => Promise.resolve({ data: null }))
      const wrapper = mountFunction(false, {}, values)
      commonViewTest(wrapper)
      wrapper.findComponent(SigninForm).vm.$emit('sign-in', values)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonToastedTest(locales.system.error, null)
    })
  })
})
