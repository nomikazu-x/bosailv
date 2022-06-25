<template>
  <div>
    <ValidationProvider v-slot="{ errors }" name="content" rules="required">
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
