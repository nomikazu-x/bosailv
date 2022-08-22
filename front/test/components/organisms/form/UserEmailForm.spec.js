import Vuetify from 'vuetify'
import { createLocalVue, mount } from '@vue/test-utils'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import EmailTextField from '~/components/organisms/textFields/EmailTextField.vue'
import PasswordTextField from '~/components/organisms/textFields/PasswordTextField.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import Component from '~/components/organisms/form/UserEmailForm.vue'

import { Helper } from '~/test/helper.js'
const helper = new Helper()

describe('UserEmailForm.vue', () => {
  const mountFunction = (user, values = null) => {
    const localVue = createLocalVue()
    const vuetify = new Vuetify()
    const wrapper = mount(Component, {
      localVue,
      vuetify,
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
    expect(wrapper.findComponent(EmailTextField).exists()).toBe(true)
    expect(wrapper.findComponent(PasswordTextField).exists()).toBe(true)
    expect(wrapper.findComponent(OrangeBtn).exists()).toBe(true)
    expect(wrapper.vm.$data.email).toBe(user.email)
    expect(wrapper.vm.$data.currentPassword).toBe('')
  }

  it('[無効]ボタンを押せない', async () => {
    const user = Object.freeze({ name: 'user1の氏名', email: 'user1@example.com' })
    const wrapper = mountFunction(user)
    commonViewTest(wrapper, user)

    // 削除
    wrapper.vm.$data.email = ''

    // 登録ボタン
    const button = wrapper.find('#user_update_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(true) // 無効
  })

  it('[有効]ボタンを押せる', async () => {
    const user = Object.freeze({ name: 'user1の氏名', email: 'user1@example.com' })
    const wrapper = mountFunction(user)
    commonViewTest(wrapper, user)

    wrapper.vm.$data.currentPassword = 'abc12345'

    expect(wrapper.vm.$data.email).toBe('user1@example.com')
    expect(wrapper.vm.$data.currentPassword).toBe('abc12345')

    // 登録ボタン
    const button = wrapper.find('#user_update_btn')
    expect(button.exists()).toBe(true)
    for (let i = 0; i < 100; i++) {
      await helper.sleep(10)
      if (!button.vm.disabled) { break }
    }
    expect(button.vm.disabled).toBe(false) // 有効
  })
})
