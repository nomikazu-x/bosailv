import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import EmailTextField from '~/components/organisms/textFields/EmailTextField.vue'
import PasswordTextField from '~/components/organisms/textFields/PasswordTextField.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import Component from '~/components/organisms/form/SigninForm.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('SigninForm.vue', () => {
  const mountFunction = (values = null) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Component, {
      localVue,
      vuetify,
      data () {
        return { ...values }
      }
    })
    expect(wrapper.vm).toBeTruthy()
    return wrapper
  }

  const commonViewTest = (wrapper) => {
    // console.log(wrapper.html())
    expect(wrapper.findComponent(TheProcessing).exists()).toBe(false)
    expect(wrapper.findComponent(EmailTextField).exists()).toBe(true)
    expect(wrapper.findComponent(PasswordTextField).exists()).toBe(true)
    expect(wrapper.findComponent(OrangeBtn).exists()).toBe(true)
  }

  it('[無効]ログインボタンを押せない', async () => {
    const wrapper = mountFunction(false)
    commonViewTest(wrapper)

    expect(wrapper.vm.$data.email).toBe('')
    expect(wrapper.vm.$data.password).toBe('')

    // ログインボタン
    const button = wrapper.find('#sign_in_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(true) // 無効
  })

  it('[有効]ログインボタンを押せる', async () => {
    const wrapper = mountFunction(false)
    commonViewTest(wrapper)

    // 入力
    wrapper.vm.$data.email = 'user1@example.com'
    wrapper.vm.$data.password = 'abc12345'

    expect(wrapper.vm.$data.email).toBe('user1@example.com')
    expect(wrapper.vm.$data.password).toBe('abc12345')

    // ログインボタン
    const button = wrapper.find('#sign_in_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (!button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(false) // 有効
  })
})
