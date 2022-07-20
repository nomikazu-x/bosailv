<template>
  <div>
    <ValidationProvider v-slot="{ errors }" :name="name" rules="required">
      <quill-editor
        v-model="valueModel"
        :options="editorOption"
        style="height: 480px;"
        :error-messages="errors"
      />
    </ValidationProvider>
  </div>
</template>

<script>
import { ValidationProvider, extend, configure, localize } from 'vee-validate'
import { required } from 'vee-validate/dist/rules'

extend('required', required)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'Editor',

  components: {
    ValidationProvider
  },

  props: {
    value: {
      type: String,
      default: undefined
    },
    name: {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      editorOption: {
        placeholder: '内容を入力'
      }
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
    }
  }
}
</script>
