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
      :append-icon="appendIcon"
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
    isShowAppendIcon: {
      type: Boolean,
      default: true
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
    appendIcon () {
      if (!this.isShowAppendIcon) {
        return ''
      }
      return this.showPassword ? 'mdi-eye' : 'mdi-eye-off'
    },
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
