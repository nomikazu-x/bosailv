<template>
  <div>
    <ValidationProvider v-slot="{ errors }" name="password" rules="required|max:20|min:8">
      <v-text-field
        v-model="valueModel"
        :value="value"
        :error-messages="errors"
        outlined
        counter
        inputmode="verbatim"
        hint="8文字以上の半角英数字のみ使用可能です"
        name="password"
        label="パスワード [8文字以上]"
        dense
        :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
        :type="showPassword ? 'text' : 'password'"
        @click:append="showPassword = !showPassword"
      />
    </ValidationProvider>

    <ValidationProvider v-slot="{ errors }" name="passwordConfirmation" rules="required|confirmed_password:password">
      <v-text-field
        v-model.trim="passwordConfirmationModel"
        :value="passwordConfirmation"
        :error-messages="errors"
        outlined
        counter
        inputmode="verbatim"
        name="password"
        label="パスワード(確認)"
        dense
        :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
        :type="showPassword ? 'text' : 'password'"
        @click:append="showPassword = !showPassword"
      />
    </ValidationProvider>
  </div>
</template>

<script>
export default {
  inheritAttrs: false,
  props: {
    value: {
      type: String,
      default: ''
    },
    passwordConfirmation: {
      type: String,
      default: undefined
    }
  },
  data () {
    return {
      showPassword: false
    }
  },
  computed: {
    valueModel: {
      get () {
        return this.value
      },
      set (newVal) {
        return this.$emit('input', newVal)
      }
    },
    passwordConfirmationModel: {
      get () {
        return this.passwordConfirmation
      },
      set (newVal) {
        return this.$emit('update:passwordConfirmation', newVal)
      }
    }
  }
}
</script>
