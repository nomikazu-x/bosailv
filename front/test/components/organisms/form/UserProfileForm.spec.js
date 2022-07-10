import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import locales from '~/locales/ja.js'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import UserNameTextField from '~/components/organisms/textFields/UserNameTextField.vue'
import PrefecturesSelect from '~/components/organisms/select/PrefecturesSelect.vue'
import CitiesSelect from '~/components/organisms/select/CitiesSelect.vue'
import ProfileTextarea from '~/components/organisms/textarea/ProfileTextarea.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'
import Component from '~/components/organisms/form/UserProfileForm.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('UserProfileForm.vue', () => {
  let axiosGetMock, toastedErrorMock, toastedInfoMock, routerPushMock, nuxtErrorMock

  beforeEach(() => {
    toastedErrorMock = jest.fn()
    toastedInfoMock = jest.fn()
    routerPushMock = jest.fn()
    nuxtErrorMock = jest.fn()
  })

  const mountFunction = (user, values = null) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Component, {
      localVue,
      vuetify,
      mocks: {
        $config: {
          apiBaseURL: 'https://example.com',
          setCitiesUrl: '/api/v1/set_cities/_id.json'
        },
        $axios: {
          get: axiosGetMock
        },
        $toasted: {
          error: toastedErrorMock,
          info: toastedInfoMock
        },
        $router: {
          push: routerPushMock
        },
        $nuxt: {
          error: nuxtErrorMock
        }
      },
      propsData: {
        user: { ...user }
      },
      data () {
        return { ...values }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  const commonViewTest = (wrapper, user) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(TheProcessing).exists()).toBe(false)
    expect(wrapper.findComponent(UserNameTextField).exists()).toBe(true)
    expect(wrapper.findComponent(PrefecturesSelect).exists()).toBe(true)
    expect(wrapper.findComponent(CitiesSelect).exists()).toBe(true)
    expect(wrapper.findComponent(ProfileTextarea).exists()).toBe(true)
    expect(wrapper.findComponent(RedBtn).exists()).toBe(true)
    expect(wrapper.vm.$data.name).toBe(user.name)
    expect(wrapper.vm.$data.profile).toBe(user.profile)
    expect(wrapper.vm.$data.selectPrefecture).toBe(user.prefecture.id)
    expect(wrapper.vm.$data.selectCity).toBe(user.city.id)
  }

  const commonApiCalledTest = (values) => {
    expect(axiosGetMock).toBeCalledTimes(1)
    expect(axiosGetMock).toBeCalledWith('https://example.com/api/v1/set_cities/1.json')
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

  describe('表示される', () => {
    const user = Object.freeze({ name: 'user_name', profile: 'user_profile', prefecture: { id: 1, name: 'prefecture' }, city: { id: 1, name: 'city' } })
    const values = Object.freeze({ selectPrefecture: 1 })
    const data = Object.freeze([{ id: 1, name: 'city1' }, { id: 2, name: 'city2' }])
    it('[無効]ボタンを押せない', async () => {
      axiosGetMock = jest.fn(() => Promise.resolve({ data }))
      const wrapper = mountFunction(user)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonViewTest(wrapper, user)

      // 削除
      wrapper.vm.$data.name = ''
      wrapper.vm.$data.profile = ''
      wrapper.vm.$data.selectPrefecture = null
      wrapper.vm.$data.selectCity = null

      // ボタン
      const button = wrapper.find('#user_update_btn')
      expect(button.exists()).toBe(true)
      for (let i = 0; i < 100; i++) {
        await helper.sleep(10)
        if (button.vm.disabled) { break }
      }
      expect(button.vm.disabled).toBe(true) // 無効
    })

    it('[有効]ボタンを押せる', async () => {
      axiosGetMock = jest.fn(() => Promise.resolve({ data }))
      const wrapper = mountFunction(user)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonViewTest(wrapper, user)

      expect(wrapper.vm.$data.name).toBe('user_name')
      expect(wrapper.vm.$data.profile).toBe('user_profile')
      expect(wrapper.vm.$data.selectPrefecture).toEqual(1)
      expect(wrapper.vm.$data.selectCity).toEqual(1)

      // 再入力
      wrapper.vm.$data.name = 'user_name2'
      wrapper.vm.$data.profile = 'user_profile'
      wrapper.vm.$data.selectPrefecture = 2
      wrapper.vm.$data.selectCity = 2

      // ボタン
      const button = wrapper.find('#user_update_btn')
      expect(button.exists()).toBe(true)
      for (let i = 0; i < 100; i++) {
        await helper.sleep(10)
        if (!button.vm.disabled) { break }
      }
      expect(button.vm.disabled).toBe(false) // 有効
    })
  })

  describe('市区町村一覧取得API', () => {
    const user = Object.freeze({ name: 'user_name', profile: 'user_profile', prefecture: { id: 1, name: 'prefecture' }, city: { id: 1, name: 'city' } })
    it('[成功]表示される', async () => {
      const data = Object.freeze([{ id: 1, name: 'city1' }, { id: 2, name: 'city2' }])
      const values = Object.freeze({ selectPrefecture: 1 })

      axiosGetMock = jest.fn(() => Promise.resolve({ data }))
      const wrapper = mountFunction(user)

      await helper.sleep(1)
      commonApiCalledTest(values)
      commonViewTest(wrapper, user)
    })
    it('[404]エラーページが表示される', async () => {
      const data = Object.freeze({ alert: 'alertメッセージ', notice: 'noticeメッセージ' })
      axiosGetMock = jest.fn(() => Promise.reject({ response: { status: 404, data } }))
      mountFunction(user)

      await helper.sleep(1)
      commonRedirectTest(data.alert, data.notice, { statusCode: 404 }, nuxtErrorMock)
    })

    it('[接続エラー]トップページにリダイレクトされる', async () => {
      axiosGetMock = jest.fn(() => Promise.reject({ response: null }))
      mountFunction(user)

      await helper.sleep(1)
      commonRedirectTest(locales.network.failure, null, { path: '/' })
    })
    it('[レスポンスエラー]トップページにリダイレクトされる', async () => {
      axiosGetMock = jest.fn(() => Promise.reject({ response: { status: 500 } }))
      mountFunction(user)

      await helper.sleep(1)
      commonRedirectTest(locales.network.error, null, { path: '/' })
    })
    it('[データなし]トップページにリダイレクトされる', async () => {
      axiosGetMock = jest.fn(() => Promise.resolve({ data: null }))
      mountFunction(user)

      await helper.sleep(1)
      commonRedirectTest(locales.system.error, null, { path: '/' })
    })
  })
})
