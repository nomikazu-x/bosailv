import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import PasswordConfirmationTextField from '~/components/organisms/textFields/PasswordConfirmationTextField.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'
import Component from '~/components/organisms/form/PasswordResetConfirmForm.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('PasswordResetConfirmForm.vue', () => {
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
    expect(wrapper.findComponent(PasswordConfirmationTextField).exists()).toBe(true)
    expect(wrapper.findComponent(RedBtn).exists()).toBe(true)
  }

  it('[無効]ボタンを押せない', async () => {
    const wrapper = mountFunction(false)
    commonViewTest(wrapper)

    expect(wrapper.vm.$data.password).toBe('')
    expect(wrapper.vm.$data.passwordConfirmation).toBe('')

    // ボタン
    const button = wrapper.find('#password_reset_confirm_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(true) // 無効
  })

  it('[有効]ボタンを押せる', async () => {
    const wrapper = mountFunction(false)
    commonViewTest(wrapper)

    // 入力
    wrapper.vm.$data.password = 'abc12345'
    wrapper.vm.$data.passwordConfirmation = 'abc12345'

    expect(wrapper.vm.$data.password).toBe('abc12345')
    expect(wrapper.vm.$data.passwordConfirmation).toBe('abc12345')

    // ボタン
    const button = wrapper.find('#password_reset_confirm_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (!button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(false) // 有効
  })
})
