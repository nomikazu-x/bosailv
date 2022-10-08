<template>
  <div>
    <quill-editor
      :content="content"
      :options="editorOption"
      :disabled="true"
    />
  </div>
</template>

<script>
export default {
  name: 'ReadOnlyEditor',

  props: {
    content: {
      type: String,
      default: undefined
    }
  },

  data () {
    return {
      editorOption: {
        readOnly: true,
        theme: 'bubble'
      }
    }
  }
}
</script>
