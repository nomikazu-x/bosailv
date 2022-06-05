<template>
  <ValidationProvider v-slot="{ errors }" name="content" rules="required">
    <quill-editor
      ref="quillEditor"
      v-model="valueModel"
      :value="value"
      :error-messages="errors"
      options="editorOption"
    />
  </ValidationProvider>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: undefined
    }
  },
  data () {
    return {
      editorOption: {
        theme: 'snow'
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
