import Vue from 'vue'
import { ValidationProvider, ValidationObserver, extend } from 'vee-validate'
import { required, email, min, confirmed, size } from 'vee-validate/dist/rules'

// 必要なルールのみインポート
extend('required', { ...required, message: '入力してください。' })
extend('email', { ...email, message: '形式が正しくありません。' })
extend('min', { ...min, message: '{length}文字以上で入力してください。' })
extend('confirmed_password', { ...confirmed, message: 'パスワードと一致していません。' })
extend('size_20MB', { ...size, message: '20MB以下のファイルを選択してください。' })

Vue.component('ValidationProvider', ValidationProvider)
Vue.component('ValidationObserver', ValidationObserver)
