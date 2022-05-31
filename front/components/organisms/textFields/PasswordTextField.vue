<template>
  <ValidationProvider v-slot="{ errors }" :name="name" :rules="passwordRule" :vid="vid">
    <v-text-field
      v-model="valueModel"
      v-bind="$attrs"
      :value="value"
      :minlength="8"
      :maxlength="20"
      :error-messages="errors"
      outlined
      counter
      inputmode="verbatim"
      hint="8文字以上の半角英数字のみ使用可能です"
      name="password"
      dense
      :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
      :type="showPassword ? 'text' : 'password'"
      @click:append="showPassword = !showPassword"
      v-on="$listeners"
    />
  </ValidationProvider>
</template>

<script>
export default {
  inheritAttrs: false,
  props: {
    value: {
      type: String,
      default: ''
    },
    name: {
      type: String,
      required: true
    },
    isConfirmed: {
      type: Boolean,
      default: false
    },
    vid: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      showPassword: false
    }
  },
  computed: {
    passwordRule () {
      const rule = 'required|max:20|min:8'
      if (this.isConfirmed) {
        return `${rule}|confirmed:confirmation`
      }
      return rule
    },
    valueModel: {
      get () {
        return this.value
      },
      set (newVal) {
        return this.$emit('input', newVal)
      }
    }
  }
}
</script>
